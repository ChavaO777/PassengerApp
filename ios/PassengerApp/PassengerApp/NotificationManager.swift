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
	public static let customSnoozeActionID = "SNOOZE_ACTION"
	private static var tripNotificationsInCenter = Int()
	
	private static var bActiveNotifications = Bool()
	private static var bCanHaveSound = Bool()
	private static var bCanHaveVibration = Bool()
	private static var anticipationNotificationMinutes = Int()
	
    static func initializeNotifications()
    {		
        let center = UNUserNotificationCenter.current()
		
		//Request notification permissions, only asked once
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if (!granted)
            {
                fatalError("You must provide notification permission >:v")
            }
        }
		
		// Create the custom actions and the category for a trip notification.
		let snoozeAction =  UNTextInputNotificationAction(identifier: customSnoozeActionID,
													title: "Posponer",
													options: .init(rawValue: 0),
													textInputButtonTitle: "Minutos",
													textInputPlaceholder: "¿Por cuántos minutos quieres posponer la notificación"
													)
		let rescheduleAction = UNNotificationAction(identifier: customRescheduleActionID,
													title: "Reagendar traslado",
													options: .foreground)
													//options: .customDismissAction)
		
		let tripCategory = UNNotificationCategory(identifier: tripNotificationID,
												  actions: [snoozeAction, rescheduleAction],
												  intentIdentifiers: [],
												  options: [UNNotificationCategoryOptions.allowInCarPlay,
															UNNotificationCategoryOptions.customDismissAction,
															UNNotificationCategoryOptions.hiddenPreviewsShowSubtitle,
															UNNotificationCategoryOptions.hiddenPreviewsShowTitle
													])
		
		// Register the notification category for trips
		center.setNotificationCategories([tripCategory])
		
		/*NotificationCenter.default.addObserver(<#T##observer: NSObject##NSObject#>, selector: #selector(self.handleTripRepetition(notification)), name:  options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
		center.addObserver(self, forKeyPath: <#T##String#>, options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil) */

        
    }
	
	//TODO: reschedule notifications for other days if the trip has days of repetition
	@objc static func handleTripRepetition (notification: Notification)
	{
		
	}
	
	static func countDeliveredNotifications() -> NSNumber
	{
		UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
			 tripNotificationsInCenter = notifications.count
		}
		return tripNotificationsInCenter as NSNumber
	}
	
    static func createTripNotification(tripName: String, tripDepartureTime: String)
    {
		updateUserConfigValues()
		
        //Only make notifications if the user has notifications activated
		if (!bActiveNotifications)
        {
            return
        }

        //Notification settings
        let content = UNMutableNotificationContent()
		content.badge = countDeliveredNotifications()
        content.title = NSString.localizedUserNotificationString(forKey: tripName, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Faltan \(anticipationNotificationMinutes) minutos para tu traslado", arguments: nil)
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

	private static func updateUserConfigValues()
	{
		let notifications = UserConfiguration.getConfiguration (key: UserConfiguration.NOTIFICATIONS_USER_DEFAULTS_KEY)
		let sound = UserConfiguration.getConfiguration(key: UserConfiguration.SOUND_USER_DEFAULTS_KEY)
		let vibration = UserConfiguration.getConfiguration(key: UserConfiguration.VIBRATION_USER_DEFAULTS_KEY)
		let minutes = UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY)
		
		bActiveNotifications = notifications as! Bool
		bCanHaveSound = sound as! Bool
		bCanHaveVibration = vibration as! Bool
		anticipationNotificationMinutes = minutes as! Int
	}
}
