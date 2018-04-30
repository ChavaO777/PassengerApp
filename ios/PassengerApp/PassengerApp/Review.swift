//
//  Review.swift
//  PassengerApp
//
//  Created by Comonfort on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Review : Codable
{
    var driver_id: Int
    var passenger_id: String
    var crafter_id: String
    var comment: String
    var score: Double
    var kindness_prize: Bool
    var cleanliness_prize: Bool
    var driving_skills_prize: Bool
    
    static let ROUTE = "reviews/"

    init(driver_id: Int, passenger_id: String, crafter_id: String, comment: String, score: Double, kindness_prize: Bool, cleanliness_prize: Bool, driving_skills_prize: Bool)
    {
        self.driver_id = driver_id
        self.passenger_id = passenger_id
        self.crafter_id = crafter_id
        self.comment = comment
        self.score = score
        self.kindness_prize = kindness_prize
        self.cleanliness_prize = cleanliness_prize
        self.driving_skills_prize = driving_skills_prize
    }
    
    func getAsJSONParams() -> [String : String]
    {
        return ["driver_id": String(driver_id), "passenger_id": passenger_id,
         "crafter_id": crafter_id, "comment": comment,
         "score": String(score), "kindness_prize": String(kindness_prize),
         "cleanliness_prize": String(cleanliness_prize), "driving_skills_prize": String(driving_skills_prize)]
    }
}
