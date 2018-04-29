//
//  ProfileViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Constants for the names of the UserDefaults keys
    let NOTIFICATIONS_USER_DEFAULTS_KEY = "notifications"
    let VIBRATION_USER_DEFAULTS_KEY = "vibration"
    let SOUND_USER_DEFAULTS_KEY = "sound"
    let NOTIFICATION_ANTICIPATION_MINUTES_KEY = "notification_anticipation_minutes"
    
    //Constants for the default values of the UserDefaults keys
    let DEFAULT_SWITCH_VALUE = false
    let DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_VALUE = 3
    
    //Outlets for the switches
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    /**
    *   Function that toggles the value of the notifications
    *   switch and updates the value in the UserDefaults.
    */
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        
        let notificationsCurrValue = sender.isOn
        UserDefaults.standard.set(notificationsCurrValue, forKey: NOTIFICATIONS_USER_DEFAULTS_KEY) //Bool
    }
    
    /**
     *  Function that toggles the value of the vibration
     *  switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleVibration(_ sender: UISwitch) {
        
        let vibrationCurrValue = sender.isOn
        UserDefaults.standard.set(vibrationCurrValue, forKey: VIBRATION_USER_DEFAULTS_KEY) //Bool
    }
    
    /**
     *  Function that toggles the value of the sound
     *  switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleSound(_ sender: UISwitch) {
        
        let soundCurrValue = sender.isOn
        UserDefaults.standard.set(soundCurrValue, forKey: SOUND_USER_DEFAULTS_KEY) //Bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Initialize the config variables
        initializeConfigVariable(configVariable: NOTIFICATIONS_USER_DEFAULTS_KEY, value: DEFAULT_SWITCH_VALUE)
        initializeConfigVariable(configVariable: VIBRATION_USER_DEFAULTS_KEY, value: DEFAULT_SWITCH_VALUE)
        initializeConfigVariable(configVariable: SOUND_USER_DEFAULTS_KEY, value: DEFAULT_SWITCH_VALUE)
        initializeConfigVariable(configVariable: NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_VALUE)
        
        //Set the switches into their correct values according to the config variables
        notificationsSwitch.setOn(UserDefaults.standard.bool(forKey: NOTIFICATIONS_USER_DEFAULTS_KEY), animated: false)
        vibrationSwitch.setOn(UserDefaults.standard.bool(forKey: VIBRATION_USER_DEFAULTS_KEY), animated: false)
        soundSwitch.setOn(UserDefaults.standard.bool(forKey: SOUND_USER_DEFAULTS_KEY), animated: false)
    }
    
    /**
     *  Function to initialize the config variables
     *
     *  @param configVariable a string corresponding to the name of the
     *  configuration variable
     *  @param value the value to be set for that key
     */
    func initializeConfigVariable(configVariable: String, value: Any) -> Void {
        
        //If the key does not exist yet
        if(!isKeyPresentInUserDefaults(key: configVariable)) {
            
            //Set it to the given value
            UserDefaults.standard.set(value, forKey: configVariable)
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
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
