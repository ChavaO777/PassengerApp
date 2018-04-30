//
//  NotificationManager.swift
//  PassengerApp
//
//  Created by Comonfort on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationManager : UNUserNotificationCenterDelegate
{
    private static var bHasNotificationPermissions = Bool()
    private static let tripNotificationID = "TRIP_NOTIFICATION"
    private static let customRescheduleActionID = "RESCHEDULE_ACTION"
    
    static func requestNotificationPermission()
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if (!granted)
            {
                fatalError("You msut provide notification permission >:v")
            }
            
            self.bHasNotificationPermissions = granted
            
            //Register notification category for trips
            
            // Create the custom actions and the category for a trip notification.
            let rescheduleAction = UNNotificationAction(identifier: customRescheduleActionID,
                                                        title: "Reagendar",
                                                        options: .foreground)
                                                        //options: .customDismissAction)
            
            let tripCategory = UNNotificationCategory(identifier: tripNotificationID,
                                                      actions: [rescheduleAction],
                                                      intentIdentifiers: [],
                                                      options: UNNotificationCategoryOptions(rawValue: 0))
            
            
            // Register the notification category
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([tripCategory])
        }
        
    }
    
    static func createTripNotification(tripName: String, tripDepartureTime: String)
    {
        //Only make notifications if the user has notifications activated
        if (!(UserConfiguration.getConfiguration (key: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY) as! Bool))
        {
            return
        }
        
        //Get user default parameters related to notifications for background
        let alarmAnticipationMinutes = (UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY)) as! Int
        let bCanHaveSound = (UserConfiguration.getConfiguration (key: UserConfiguration.SOUND_USER_DEFAULTS_KEY)) as! Bool

        //Notification settings
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: tripName, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Faltan \(alarmAnticipationMinutes) minutos para tu traslado", arguments: nil)
        content.categoryIdentifier = tripNotificationID
        if (bCanHaveSound)
        {
            content.sound = UNNotificationSound.default()
        }
        
        // Configure the time trigger
        var dateInfo = DateComponents()
        //Get the time from the string defining a trips departure time
        let splitTime = tripDepartureTime.components(separatedBy: ":")
        dateInfo.hour = Int(splitTime[0])
        dateInfo.minute = Int(splitTime[1])
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "Trip_\(tripName)", content: content, trigger: trigger)
        
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    //MARK: - User Notification Center Delegate Methods
    
    //Called when a notification is delivered with the app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        
        if ((UserConfiguration.getConfiguration (key: UserConfiguration.SOUND_USER_DEFAULTS_KEY)) as! Bool)
        {
            // Play a sound if the user has such configuration
            completionHandler([.alert ,.sound])
        }
        else
        {
            // Play a sound if the user has such configuration
            completionHandler([.alert])
        }
    }
    
    //Called when the user gets the notification and acts upong it
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == NotificationManager.tripNotificationID {
            
            // Handle the actions for the reschedule action
            if response.actionIdentifier == NotificationManager.customRescheduleActionID {
                
                // Invalidate the old timer and create a new one. . .
            }
            else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                // The user dismissed the notification without taking action
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // The user launched the app
            }
        }
    }

    
    /*
    //Gets all our notifications still in the user´s notification center
    getDeliveredNotificationsWithCompletionHandler:
    //remove one of them
    removeDeliveredNotificationsWithIdentifiers:
    //To cancel an individual notification before it is delivered or to cancel a repeating notification
    removePendingNotificationRequestsWithIdentifiers:
     */
}
