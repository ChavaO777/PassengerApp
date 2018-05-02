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
        
        //TODO: Check if the user is signed in
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarNVC = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as!  UITabBarController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarNVC
        self.window?.makeKeyAndVisible()
        
        print("Attempting to load notification for trip \"\(tripName)\"")
        
        //let tripVC = mainStoryboard.instantiateViewController(withIdentifier: "TripList")
        //let tripVCIndex = tabBarNVC.childViewControllers.index(of: tripVC)
        
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
            // Play a sound if the user has such configuration
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
        
        if response.notification.request.content.categoryIdentifier == NotificationManager.tripNotificationID {
            
            // Handle the actions for the reschedule action
            if response.actionIdentifier == NotificationManager.customRescheduleActionID {
                
                //Gets the trip name from the notification request id (with format "Trip_<tripName>")
                let tripName = response.notification.request.identifier.components(separatedBy: "_")[1]

                //Load the TripViewController with that trip's data
                loadTripFromNotification (tripName: tripName)
            }
            else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                // The user dismissed the notification without taking action
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // The user launched the app
            }
        }
        completionHandler()
    }
}
