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
    
    static let ROUTE = "drivers/"
}
