//
//  ExtensionAppDelegate.swift
//  PassengerApp
//
//  Created by Comonfort on 5/1/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation
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
    
    //Called when the user gets the notification and acts upong it
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == NotificationManager.tripNotificationID {
            
            // Handle the actions for the reschedule action
            if response.actionIdentifier == NotificationManager.customRescheduleActionID {
                //User chose to reschedule
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
