//
//  HTTPHandler.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class HTTPHandler{
    
    static let URL = "http://localhost:8000/api"
    
    @objc static func makeHTTPGetRequest(route: String, httpBody: Data?, callbackFunction: @escaping (_ data: Data?) -> Void){
        
        makeHTTPRequest(route: route, httpMethod: "GET", httpBody: httpBody, callbackFunction: callbackFunction)
    }
    
    @objc static func makeHTTPPutRequest(route: String, httpBody: Data?, callbackFunction: @escaping (_ data: Data?) -> Void){
        
        makeHTTPRequest(route: route, httpMethod: "PUT", httpBody: httpBody, callbackFunction: callbackFunction)
    }
    
    /**
     *  Function that makes an HTTP request to the REST API in
     *  the backend server
     *
     *  @param route the route to be used in the HTTP request
     *  @param httpMethod the HTTP method to be used in the request
     *  @param httpBody a Data? corresponding to a JSON file to be passed to the request.
     *         If a request does not require a body, this parameter can be sent as nil.
     *  @param callbackFunction the function to be called within this function
     */
    @objc static func makeHTTPRequest(route: String, httpMethod: String, httpBody: Data?, callbackFunction: @escaping (_ data: Data?) -> Void) {
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        let ROUTE_URL = self.URL + route
        let url = NSURL(string: ROUTE_URL)
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        dataTask = defaultSession.dataTask(with: request as URLRequest){
            
            data, response, error in
            
            if error != nil {
                
                print(error!.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                
                //If the request was successful
                if httpResponse.statusCode == 200 {
                    
                    DispatchQueue.main.async {
                        
                        //Call the call-back function with the data received from the request
                        callbackFunction(data)
                    }
                }
            }
        }
        
        dataTask?.resume()
    }
    
    @objc static func makeHTTPPostRequest(route: String, parameters: [String : String], callbackFunction: @escaping (_ data: Data?) -> Void){
        
        let ROUTE_URL = self.URL + route
        let url = NSURL (string: ROUTE_URL)
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url! as URL)
        request.encodeParameters(parameters: parameters)
        
        var dataTask: URLSessionDataTask?
        
        dataTask = session.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print (error!.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201{
                    DispatchQueue.main.async {
                        
                        //If there is a call-back function, call it with the data received from the request
                        callbackFunction(data)
                        
                        print ("Successful POST request to " + ROUTE_URL)
                    }
                }
                else {
                   
                    DispatchQueue.main.async {
                        
                        //If there is a call-back function, call it with the data received from the request
                        callbackFunction(data)

                        print ("Response: " + String(httpResponse.statusCode))
                    }
                }
            }
        }
        
        dataTask?.resume()
    }
}
