//
//  Crafter.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Crafter : Decodable
{
    let id: String
    let name: String
    let lat: Double
    let lng: Double
    let isActive: Bool
    let total_seats: Int
    let occupied_seats: Int
    static let ROUTE = "/crafters"
    let ICON_NAME_STRING = "icon_crafter.png"
    
    /**
     *  Function to create a snippet for the crafter's marker
     *
     *  @returns markerSnippet a string corresponding to the crafter's marker's snippet
     */
    func getMarkerSnippet() -> String {
        
        let markerSnippet = "Capacidad: " + String(self.total_seats) + " pasajeros\nAsientos disponibles: " + String(self.total_seats - self.occupied_seats)
        return markerSnippet
    }
}
