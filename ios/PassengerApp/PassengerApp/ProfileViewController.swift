//
//  ProfileViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Constants for the names of the user default keys
    let NOTIFICATIONS_USER_DEFAULTS_KEY = "notifications"
    let VIBRATION_USER_DEFAULTS_KEY = "vibration"
    let SOUND_USER_DEFAULTS_KEY = "sound"
    let DEFAULT_BOOLEAN_CONFIG_VARIABLE_VALUE = false
    
    //Outlets for the switches
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    /**
    * Function that toggles the value of the notifications
    * switch and updates the value in the UserDefaults.
    */
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        
        let notificationsCurrValue = sender.isOn
        UserDefaults.standard.set(notificationsCurrValue, forKey: NOTIFICATIONS_USER_DEFAULTS_KEY) //Bool
    }
    
    /**
     * Function that toggles the value of the vibration
     * switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleVibration(_ sender: UISwitch) {
        
        let vibrationCurrValue = sender.isOn
        UserDefaults.standard.set(vibrationCurrValue, forKey: VIBRATION_USER_DEFAULTS_KEY) //Bool
    }
    
    /**
     * Function that toggles the value of the sound
     * switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleSound(_ sender: UISwitch) {
        
        let soundCurrValue = sender.isOn
        UserDefaults.standard.set(soundCurrValue, forKey: SOUND_USER_DEFAULTS_KEY) //Bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Initialize the config variables
        initializeConfigVariable(configVariable: NOTIFICATIONS_USER_DEFAULTS_KEY)
        initializeConfigVariable(configVariable: VIBRATION_USER_DEFAULTS_KEY)
        initializeConfigVariable(configVariable: SOUND_USER_DEFAULTS_KEY)
        
        //Set the switches into their correct values according to the config variables
        notificationsSwitch.setOn(UserDefaults.standard.bool(forKey: NOTIFICATIONS_USER_DEFAULTS_KEY), animated: false)
        vibrationSwitch.setOn(UserDefaults.standard.bool(forKey: VIBRATION_USER_DEFAULTS_KEY), animated: false)
        soundSwitch.setOn(UserDefaults.standard.bool(forKey: SOUND_USER_DEFAULTS_KEY), animated: false)
    }
    
    /**
     * Function to initialize the config variables for notifications,
     * vibration and sound.
     */
    func initializeConfigVariable(configVariable: String) -> Void {
        
        //If the key does not exist yet
        if(!isKeyPresentInUserDefaults(key: configVariable)) {
            
            //Set it to its default value
            setDefaultBooleanConfigurationVariable(configVariable: configVariable)
        }
    }
    
    /**
    *   Function to set a boolean config variable to the value
    *   DEFAULT_BOOLEAN_CONFIG_VARIABLE_VALUE
    */
    func setDefaultBooleanConfigurationVariable(configVariable: String) -> Void {
        
        UserDefaults.standard.set(DEFAULT_BOOLEAN_CONFIG_VARIABLE_VALUE, forKey: configVariable)
    }
    
    /**
    *   Function to determine whether a given key is present in the
    *   UserDefaults
    */
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
