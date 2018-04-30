//
//  ExtensionURLRequest.swift
//  PassengerApp
//
//  Created by Comonfort on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

extension URLRequest {
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "POST"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

/*
 /*UIApplication.shared.isNetworkActivityIndicatorVisible = true
 let url = NSURL (string: ReviewViewController.BACKEND_URL + ReviewViewController.REVIEWS_API_URL)
 
 var dataTask: URLSessionDataTask?
 let config = URLSessionConfiguration.default
 config.httpAdditionalHeaders = [
 "Accept" : "application/json",
 "Content-Type" : "application/x-www-form-urlencoded"
 ]
 
 let session = URLSession(configuration: config)
 var request = URLRequest(url: url! as URL)
 request.encodeParameters(parameters: ["driver_id": String(review.driver_id), "passenger_id": review.passenger_id,
 "crafter_id": review.crafter_id, "comment": review.comment,
 "score": String(review.score), "kindness_prize": String(review.kindness_prize),
 "cleanliness_prize": String(review.cleanliness_prize), "driving_skills_prize": String(review.driving_skills_prize)])
 
 dataTask = session.dataTask(with: request) {
 data, response, error in
 
 if error != nil {
 print (error!.localizedDescription)
 }
 else if let httpResponse = response as? HTTPURLResponse {
 if httpResponse.statusCode == 200 {
 DispatchQueue.main.async {
 UIApplication.shared.isNetworkActivityIndicatorVisible = false
 print ("Review sent succesfully")
 }
 }
 else {
 print ("Response: " + String(httpResponse.statusCode))
 }
 }
 }
 dataTask?.resume() */
*/
