//
//  ExtensionAppDelegate.swift
//  PassengerApp
//
//  Created by Comonfort on 5/1/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox.AudioServices

extension AppDelegate : UNUserNotificationCenterDelegate
{
    //Helps handling a notifiction reschedule action, by taking the user to that trip edition
    func loadTripFromNotification (tripName: String)
    {
        //Create the TabBarNavController
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarNVC = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as!  UITabBarController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarNVC
        self.window?.makeKeyAndVisible()
        
        print("Attempting to load notification for trip \"\(tripName)\"")
        
        //let tripVC = mainStoryboard.instantiateViewController(withIdentifier: "TripList")
        //let tripVCIndex = tabBarNVC.childViewControllers.index(of: tripVC)

        //Make the segues all the way to the trip details view
        self.window?.rootViewController?.childViewControllers[0].childViewControllers[0].performSegue(withIdentifier: "loadTripSegue", sender: Trip.findTrip(withName: tripName)) //As sender, pass the trip to load :s
    }
    
    //Called when a notification is delivered with the app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let sounds = (UserConfiguration.getConfiguration (key: UserConfiguration.SOUND_USER_DEFAULTS_KEY)) as! Bool
        let notifications = (UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY)) as! Bool
        let vibration = (UserConfiguration.getConfiguration(key: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY)) as! Bool
    
        //The notification must not be shown if the user silenced them
        if !notifications
        {
            print ("Notifications setting off, avoiding notification")
            return
        }
        
        //Provide sound if the config allows it
        if sounds
        {
            //Also check for vibration setting
            if vibration
            {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            completionHandler([.alert , .badge ,.sound])
        }
        else
        {
            if vibration
            {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            completionHandler([.alert, .badge])
        }
        
        //Delivered notification
        
    }
    
    //Called when the user gets the notification and acts upong it
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Handle only trip notifications
        if response.notification.request.content.categoryIdentifier == NotificationManager.tripNotificationID {

            let vibration = (UserConfiguration.getConfiguration(key: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY)) as! Bool
            
            //Also check for vibration setting
            if vibration
            {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            //Gets the trip name from the notification request id (with format "Trip_<tripName>")
            let tripName = response.notification.request.identifier.components(separatedBy: "_")[1]
            
            // Handle the actions for the reschedule action
            if response.actionIdentifier == NotificationManager.customRescheduleActionID {
                
                //Only reschedule if the user has its token, meaning he left the session open
                if (!canEnterApp())
                {
                    //take the user to the login screen
                    takeUserToLogin()
                    return
                }
                
                //Load the TripViewController with that trip's data
                loadTripFromNotification (tripName: tripName)
            }
            else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                // The user dismissed the notification without taking action
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // The user launched the app
            }
            //Handle snooze action ID
            else if response.actionIdentifier == NotificationManager.customSnoozeActionID
            {
                //Only snooze if the user has its token, meaning he left the session open
                if (!canEnterApp())
                {
                    //take the user to the login screen
                    takeUserToLogin()
                    return
                }
                
                //Parse the user input as a number
                //let textResponse = response as! UNTextInputNotificationResponse
                
                var minutesSnooze: Int? = nil//Int(textResponse.userText) + anticipationMinutes
                
                if minutesSnooze == nil
                {
                    //5 is the default, in case of invalid input
                    minutesSnooze = 2;
                }
                
                //Format minutesSnooze from now, as a string in format "HH:MM"
                let date = Date().addingTimeInterval(Double(minutesSnooze! * 60))
                let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

                let hour = components.hour!
                let minute = components.minute!
                
                //Create the new notification
                NotificationManager.createTripNotification(tripName: tripName, tripDepartureTime: "\(String(hour)):\(String(minute))", tripDate: Date())
                
            }
        }
        completionHandler()
    }
    
    //Checks if the user is allowed to go into the app
    func canEnterApp() -> Bool
    {
        let token = (UserConfiguration.getConfiguration(key: UserConfiguration.TOKEN_KEY)) as! String
        
        //An empty token "" means the user is not signed in
        return token != ""
    }
    
    func takeUserToLogin()
    {
        //Go to login
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login = mainStoryboard.instantiateViewController(withIdentifier: "loginView") as!  UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = login
        self.window?.makeKeyAndVisible()
    }
}
