//
//  ExtensionAppDelegate.swift
//  PassengerApp
//
//  Created by Comonfort on 5/1/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate : UNUserNotificationCenterDelegate
{
    //Called when a notification is delivered with the app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let sounds = UserConfiguration.getConfiguration (key: UserConfiguration.SOUND_USER_DEFAULTS_KEY)
        
        if ((sounds) as! Bool)
        {
            // Play a sound if the user has such configuration
            completionHandler([.alert , .badge ,.sound])
        }
        else
        {
            // Play a sound if the user has such configuration
            completionHandler([.alert, .badge])
        }
    }
    
    func loadTripFromNotification (tripName: String)
    {

        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarNVC = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as!  UITabBarController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarNVC
        self.window?.makeKeyAndVisible()
        
        print("Attempting to load notification for trip \"\(tripName)\"")
        
        //let tripVC = mainStoryboard.instantiateViewController(withIdentifier: "TripList")
        //let tripVCIndex = tabBarNVC.childViewControllers.index(of: tripVC)
        
    self.window?.rootViewController?.childViewControllers[0].childViewControllers[0].performSegue(withIdentifier: "loadTripSegue", sender: Trip.findTrip(withName: tripName)) //As sender, pass the trip to load :s
        
        /*
            let vc = TripViewController.storyboard!.instantiateViewController(withIdentifier: "TripView") as! UINavigationController
            //className.present(vc, animated: false, completion: nil)
         
            let navBarNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UINavigationController
         
         
         
            self.addChildViewController(reviewVC)
            reviewVC.view.frame = self.view.frame
            self.view.addSubview(reviewVC.view)
            reviewVC.didMove(toParentViewController: self)
        */
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
