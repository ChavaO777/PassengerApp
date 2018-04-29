//
//  Crafter.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

struct Crafter : Decodable
{
    let id: String
    let name: String
    let lat: Double
    let lng: Double
    let isActive: Bool
    let total_seats: Int
    let occupied_seats: Int
}
