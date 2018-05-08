//
//  Station.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/29/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

/**
 *  Model of the Station entity
 */

class Station : Codable
{
    private var id: Int
    private var name: String
    private var lat: Double
    private var lng: Double
    private var waiting_people: Int
    private var next_crafter_arrival_time: Double
    private var next_crafter_id: String
    
    static let ROUTE = "/stations"
    let ICON_NAME_STRING = "icon_station.png"
    
    public required init(){
        id = 0
        name = ""
        lat = 0
        lng = 0
        waiting_people = 0
        next_crafter_arrival_time = 0.0
        next_crafter_id = ""
    }
    
    public convenience init(_waiting_people: Int, _next_crafter_arrival_time: Double){
        self.init()
        waiting_people = _waiting_people
        next_crafter_arrival_time = _next_crafter_arrival_time
    }
    
    /**
     *  Function to create a snippet for the station's marker
     *
     *  @returns markerSnippet a string corresponding to the station's marker's snippet
     */
    func getMarkerSnippet(waiting_people: Int, next_crafter_arrival_time: Double) -> String {
        
        let markerSnippet = "Personas esperando una crafter: " + String(self.waiting_people) + "\nSiguiente crafter en: " + String(self.next_crafter_arrival_time) + " min."
        return markerSnippet
    }
    
    public func getId() -> Int {
        
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
    
    public func getWaitingPeople() -> Int {
        
        return waiting_people
    }
    
    public func getNextCrafterArrivalTime() -> Double {
        
        return next_crafter_arrival_time
    }
    
    public func getNextCrafterId() -> String {
        
        return next_crafter_id
    }
}
