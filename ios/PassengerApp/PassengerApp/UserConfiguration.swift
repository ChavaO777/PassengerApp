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
    static let PASSENGER_FIRST_NAME = "passenger_first_name"
    static let TOKEN_KEY = "token"
    static let EXPIRATION_TIME_KEY = "expirationTime"
    static let CRAFTER_COUNT_KEY = "crafter_count"
    
    //Constants for the default values of the UserDefaults keys
    static let DEFAULT_SWITCH_VALUE = true
    static let DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MIN_VALUE = 1
    static let DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE = 5
    
    /*
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
        
    // MARK: - User Defaults
    
    /**
     *  Ensures that all the required user configuration exists
     *
     */
    public static func initializeUserConfiguration()
    {
        //Initialize the config variables
        initializeConfigVariable(configVariableKey: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY, value: UserConfiguration.DEFAULT_SWITCH_VALUE) //Boolean
        initializeConfigVariable(configVariableKey: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY, value: UserConfiguration.DEFAULT_SWITCH_VALUE) //Boolean
        initializeConfigVariable(configVariableKey: UserConfiguration.SOUND_USER_DEFAULTS_KEY, value: UserConfiguration.DEFAULT_SWITCH_VALUE) //Boolean
        initializeConfigVariable(configVariableKey: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: (UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MIN_VALUE + UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE)/2) //Int
    }
    
    /**
     *  Function to initialize the config variables
     *
     *  @param configVariableKey a string corresponding to the key of the
     *  configuration variable
     *  @param value the value to be set for that key
     */
    private static func initializeConfigVariable(configVariableKey: String, value: Any) -> Void {
        
        //If the key does not exist yet
        if(!isKeyPresentInUserDefaults(key: configVariableKey)) {
            
            //Set it to the given value
            UserConfiguration.setConfiguration(key: configVariableKey, value: value)
        }
    }
    
    /**
     *  Function to determine whether a given key is present in the
     *  UserDefaults
     *
     *  @param key the name of the key whose existence in the UserDefaults
     *  is to be checked
     *  @returns True if the key exists in the UserDefaults. Else, false
     */
    public static func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
