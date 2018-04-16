//
//  Trip.swift
//  PassengerApp
//
//  Created by Comonfort on 4/16/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class Trip {
    //MARK: Properties
    
    var alarmName: String
    var repetitionDays = [Bool]()
    var departureTime: String
    var alarmDate: Date
    var active: Bool
    
    
    //MARK: Initialization
    
    init?(alarmName: String, repetitionDays: [Bool], departureTime: String, alarmDate: Date, active: Bool) {
        
        if alarmName.isEmpty || repetitionDays.count < 7 || departureTime.isEmpty
        {
            return nil
        }
        
        self.alarmName = alarmName
        self.repetitionDays = repetitionDays
        self.departureTime = departureTime
        self.alarmDate = alarmDate
        self.active = active
        
        
    }
}
