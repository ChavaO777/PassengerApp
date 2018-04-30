//
//  UserConfiguration.swift
//  PassengerApp
//
//  Created by Salvador Orozco Villalever on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation

/**
 *  Class that handles the user configuration variables.
 */

class UserConfiguration {
    
    //Constants for the names of the UserDefaults keys
    static let NOTIFICATIONS_USER_DEFAULTS_KEY = "notifications"
    static let VIBRATION_USER_DEFAULTS_KEY = "vibration"
    static let SOUND_USER_DEFAULTS_KEY = "sound"
    static let NOTIFICATION_ANTICIPATION_MINUTES_KEY = "notification_anticipation_minutes"
    static let PASSENGER_KEY = "passenger"
    static let TOKEN_KEY = "token"
    static let EXPIRATION_TIME_KEY = "expirationTime"
    
    //Constants for the default values of the UserDefaults keys
    static let DEFAULT_SWITCH_VALUE = false
    static let DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MIN_VALUE = 1
    static let DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE = 5
    
    /**
     *  Function to set a user configuration variable
     *
     *  @param key the key corresponding to that variable
     *  @param value the new value of that configuration variable
     */
    static func setConfiguration(key: String, value: Any){
        
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /**
     *  Function to get a user configuration variable
     *
     *  @param key the key corresponding to that variable
     */
    static func getConfiguration(key: String) -> Any {
        
        return UserDefaults.standard.object(forKey: key) as Any
    }
}
