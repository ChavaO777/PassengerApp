//
//  Station.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Station : Codable
{
    let id: Int
    let name: String
    var lat: Double
    var lng: Double
    var waiting_people: Int
    var next_crafter_arrival_time: Double
    var next_crafter_id: String
    
    static let ROUTE = "stations/"
    let ICON_NAME_STRING = "icon_station.png"
    
    /**
     *  Function to create a snippet for the station's marker
     *
     *  @returns markerSnippet a string corresponding to the station's marker's snippet
     */
    func getMarkerSnippet() -> String {
        
        let markerSnippet = "Personas esperando una crafter: " + String(self.waiting_people) + "\nSiguiente crafter en: " + String(self.next_crafter_arrival_time) + " min."
        return markerSnippet
    }
}
