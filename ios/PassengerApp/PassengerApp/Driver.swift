//
//  Driver.swift
//  PassengerApp
//
//  Created by Comonfort on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Driver : Codable
{
    var id: Int
    var first_name: String
    var last_name: String
    var review_count: Int
    var review_avg: Double
    var kindness_prize_count: Int
    var cleanliness_prize_count: Int
    var driving_skills_prize_count: Int
    
    static let ROUTE = "/drivers"
    
    init(id: Int, first_name: String, last_name: String, review_count: Int, review_avg: Double, kindness_prize_count: Int, cleanliness_prize_count: Int, driving_skills_prize_count: Int)
    {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.review_count = review_count
        self.review_avg = review_avg
        self.kindness_prize_count = kindness_prize_count
        self.cleanliness_prize_count = cleanliness_prize_count
        self.driving_skills_prize_count = driving_skills_prize_count
    }
}
