//
//  HTTPHandler.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class HTTPHandler{
    
    static let defaultSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?
    static let URL = "http://localhost:8000/api"
    
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
        
        let ROUTE_URL = URL + route
        
        if dataTask != nil {
            
            dataTask?.cancel()
        }
        
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
}
