//
//  NotificationManager.swift
//  PassengerApp
//
//  Created by Comonfort on 4/30/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationManager
{
    public static let tripNotificationID = "TRIP_NOTIFICATION"
    public static let customRescheduleActionID = "RESCHEDULE_ACTION"
    
    static func requestNotificationPermission()
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if (!granted)
            {
                fatalError("You must provide notification permission >:v")
            }
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
	
	//Remove a notification for a pending trip
    static func cancelTripNotification (forTripName tripName: String)
    {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Trip_\(tripName)"])
    }
    
    /*
    //Gets all our notifications still in the user´s notification center
    getDeliveredNotificationsWithCompletionHandler:
	*/

}
