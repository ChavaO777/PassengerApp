//
//  Passenger.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Passenger : Decodable {
    
    let id: String
    let first_name: String
    let last_name: String
    let token: String //The token received after a successful login
    static let ROUTE = "/login"
    
    init(id: String, first_name: String, last_name: String, token: String) {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.token = token
    }
}
