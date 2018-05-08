
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
	public static let messageNotificationID = "MESSAGE_NOTIFICATION"
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
		/*let snoozeAction =  UNTextInputNotificationAction(identifier: customSnoozeActionID,
													title: "Posponer",
													options: [],
													textInputButtonTitle: "Minutos",
													textInputPlaceholder: "¿Por cuántos minutos quieres posponer la notificación"
*/
		let snoozeAction =  UNNotificationAction(identifier: customSnoozeActionID,
														  title: "Posponer",
														  options: []
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
		
		//notification type for doing simple message notifications
		let messageNotificationCategory = UNNotificationCategory(identifier: messageNotificationID,
												  actions: [],
												  intentIdentifiers: [],
												  options: [.hiddenPreviewsShowSubtitle,
															.hiddenPreviewsShowTitle,
															.allowInCarPlay])
		
		// Register the notification category for trips
		center.setNotificationCategories([tripCategory, messageNotificationCategory])
        
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
	
	//Returns a date components containing the desired date and time, that the notification should go off
	static func getNotificationDateComponents (fromTripDate tripDate: Date, fromTripTime tripDepartureTime: String) -> DateComponents
	{
		//Get the time from the string defining a trips departure time
		let splitTime = tripDepartureTime.components(separatedBy: ":")
		//Move departure time, to account for the anticipation minutes configuration
		let minutes = Int(splitTime[1])
		let hours = Int(splitTime[0])
		
		//construct components from the trip date, then change the hour and minutes to match the departureTime
		var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tripDate)
		dateComponents.hour = hours
		dateComponents.minute = minutes
		
		//Create new date, with the anticipationMinutes considered
		let newDate = Calendar.current.date(from: dateComponents)!.addingTimeInterval(Double(-60 * anticipationNotificationMinutes))
		
		var finalComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
		
		finalComponents.second = 0
		
		//Create final date components
		return finalComponents

	}
	
	//Create a notification conveying a single message to the user (instead of making an alert that requires user input)
	static func createMessageNotification(message: String)
	{
		let content = UNMutableNotificationContent()
		
		//Set content
		content.title = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
		content.categoryIdentifier = messageNotificationID
		
		//Create time trigger
		var targetDateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
		targetDateComp.second = targetDateComp.second! + 1
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: targetDateComp, repeats: false)

		// Create the request object.
		let request = UNNotificationRequest(identifier: "Msg_\(message)", content: content, trigger: trigger)
		
		// Schedule the request.
		let center = UNUserNotificationCenter.current()
		center.add(request) { (error : Error?) in
			if let theError = error {
				print(theError.localizedDescription)
			}
		}
	}
	
	static func createTripNotification(tripName: String, tripDepartureTime: String, tripDate: Date)
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
		
		
		//create time trigger to indicate when the notifiation should appear
		let trigger = UNCalendarNotificationTrigger(dateMatching: getNotificationDateComponents(fromTripDate: tripDate, fromTripTime:  tripDepartureTime), repeats: false)
        
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
		let minutes = UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY) as Any!
		
		bActiveNotifications = notifications as! Bool
		bCanHaveSound = sound as! Bool
		bCanHaveVibration = vibration as! Bool
		
		do{
			anticipationNotificationMinutes = minutes as! Int
		}
		catch let error{
			print(error)
			//hardcoding. TODO: Fix this!
			//anticipationNotificationMinutes = 1
		}
	}
}
