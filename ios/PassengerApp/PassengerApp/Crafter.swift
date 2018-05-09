//
//  Crafter.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

class Crafter : Codable
{
    private var id: String
    private var name: String
    private var lat: Double
    private var lng: Double
    private var isActive: Bool
    private var total_seats: Int
    private var occupied_seats: Int
    
    static let ROUTE = "/crafters"
    let ICON_NAME_STRING = "icon_crafter.png"
    
    public required init(){
        id = ""
        name = ""
        lat = 0
        lng = 0
        isActive = false
        total_seats = 0
        occupied_seats = 0
    }
    
    public convenience init(_total_seats: Int, _occupied_seats: Int){
        self.init()
        total_seats = _total_seats
        occupied_seats = _occupied_seats
    }
    
    /**
     *  Function to create a snippet for the crafter's marker
     *
     *  @returns markerSnippet a string corresponding to the crafter's marker's snippet
     */
    public func getMarkerSnippet(total_seats: Int, occupied_seats: Int) -> String {
        
        let markerSnippet = "Capacidad: " + String(self.total_seats) + " pasajeros\nAsientos disponibles: " + String(self.total_seats - self.occupied_seats)
        return markerSnippet
    }
    
    public func getId() -> String {
        
        return self.id
    }
    
    public func getName() -> String {
    
        return self.name
    }
    
    public func getLat() -> Double {
    
        return self.lat
    }
    
    public func getLng() -> Double {
    
        return self.lng
    }
    
    public func getIsActive() -> Bool {
        
        return self.isActive
    }
    
    public func getTotalSeats() -> Int {
        
        return self.total_seats
    }
    
    public func getOccupiedSeats() -> Int {
        
        return self.occupied_seats
    }
}
