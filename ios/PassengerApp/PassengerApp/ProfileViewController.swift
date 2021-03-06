//
//  ProfileViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Outlets for the switches
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var notificationAnticipationMinutes: UILabel!
    @IBOutlet weak var NotificationAnticipationMinutesStepper: UIStepper!
    
    @IBOutlet weak var passengerName: UILabel!
    
    @IBOutlet weak var tripCounter: UILabel!
    
    /**
    *   Function that toggles the value of the notifications
    *   switch and updates the value in the UserDefaults.
    */
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        
        let notificationsCurrValue = sender.isOn
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY, value: notificationsCurrValue)
    }
    
    /**
     *  Function that toggles the value of the vibration
     *  switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleVibration(_ sender: UISwitch) {
        
        let vibrationCurrValue = sender.isOn
        UserConfiguration.setConfiguration(key: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY, value: vibrationCurrValue)
    }
    
    /**
     *  Function that toggles the value of the sound
     *  switch and updates the value in the UserDefaults.
     */
    @IBAction func toggleSound(_ sender: UISwitch) {
        
        let soundCurrValue = sender.isOn
        UserConfiguration.setConfiguration(key: UserConfiguration.SOUND_USER_DEFAULTS_KEY, value: soundCurrValue)
    }
    
    @IBAction func signOut()
    {
        //Set empty strings for user data defaults (his id, name and token)
        UserConfiguration.setConfiguration(key: UserConfiguration.PASSENGER_FIRST_NAME, value: "" as Any)
        UserConfiguration.setConfiguration(key: UserConfiguration.PASSENGER_KEY, value: "" as Any)
        UserConfiguration.setConfiguration(key: UserConfiguration.TOKEN_KEY, value: "" as Any)
        
        self.performSegue(withIdentifier: "signOut", sender: self)
    }

    @IBAction func editNotificationAnticipationMinutes(_ sender: UIStepper) {
        
        //Get the new value from the stepper
        let newNotificationAnticipationMinutes = Int(sender.value).description
        //Assign the new value to the label
        notificationAnticipationMinutes.text = newNotificationAnticipationMinutes
        //Save the new value in the UserDefaults
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: newNotificationAnticipationMinutes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Set the first name of the passenger at the top of the view
        passengerName.text = UserConfiguration.getConfiguration(key: UserConfiguration.PASSENGER_FIRST_NAME) as? String
        
        setTripCounter()

        //Set the switches into their correct values according to the config variables
        notificationsSwitch.setOn(UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY) as! Bool, animated: false)
        vibrationSwitch.setOn(UserConfiguration.getConfiguration(key: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY) as! Bool, animated: false)
        soundSwitch.setOn(UserConfiguration.getConfiguration(key: UserConfiguration.SOUND_USER_DEFAULTS_KEY) as! Bool, animated: false)
        
        //Set the stepper to its correct value according to the config variable
//        NotificationAnticipationMinutesStepper.value = Double(UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY) as! Double)
        NotificationAnticipationMinutesStepper.value = 3 //TODO: fix this call to get the user configuration
    
        //Set the stepper configuration
        NotificationAnticipationMinutesStepper.wraps = true
        NotificationAnticipationMinutesStepper.autorepeat = true
        NotificationAnticipationMinutesStepper.minimumValue = Double(UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MIN_VALUE)
        NotificationAnticipationMinutesStepper.maximumValue = Double(UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE)
    }
    
    private func setTripCounter() {
        
        let passengerId = UserConfiguration.getConfiguration(key: UserConfiguration.PASSENGER_KEY) as! String
        let url = Passenger.TRIP_COUNTER_ROUTE + "/" + passengerId
        HTTPHandler.makeHTTPGetRequest(route: url, httpBody: nil, callbackFunction: self.handleReviewsByPassengerResponse)
    }
    
    private func handleReviewsByPassengerResponse(data: Data?) {
        
        do{
            //Decode the response to the reviews by passenger call
            let reviewsByPassengerResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //Get the count of the reviews in the result set
            let reviewsByCurrentPassenger = String((reviewsByPassengerResponseDictionary! as AnyObject).count)
            //Assign the count to the label below the passenger's name
            tripCounter.text = tripCounter.text! + reviewsByCurrentPassenger
        
        } catch let jsonError{
            
            print(jsonError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTripReview(_ sender: UIButton) {
  
        //Create popup for new trip data
        let reviewVC = UIStoryboard (name: "Main" /*same story board, different view/scene */, bundle: nil).instantiateViewController(withIdentifier: "ReviewView") as! ReviewViewController
        
        self.addChildViewController(reviewVC)
        reviewVC.view.frame = self.view.frame
        self.view.addSubview(reviewVC.view)
        reviewVC.didMove(toParentViewController: self)
    }
}
