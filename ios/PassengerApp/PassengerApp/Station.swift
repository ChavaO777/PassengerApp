//
//  Station.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

struct Station : Decodable
{
    let id: Int
    let name: String
    let lat: Double
    let lng: Double
    let waiting_people: Int
    let next_crafter_arrival_time: Double
    let next_crafter_id: String
}
