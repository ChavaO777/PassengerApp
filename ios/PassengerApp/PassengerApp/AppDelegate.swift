//
//  AppDelegate.swift
//  PassengerApp
//
//  Created by Comonfort on 3/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let APP_LAUNCH_TIME_KEY = "APP_LAUNCH_TIME_KEY"
    let START_TIME:CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyCwQ3-yJz_IvPrO-uGEgmEOckI2RO2tTcw")
        
        //Declare configuration variables if they don´t exist
        UserConfiguration.initializeUserConfiguration()
        
        //Provide delegate to Notifications Center
        UNUserNotificationCenter.current().delegate = self
        
        //Request notification permission
        NotificationManager.initializeNotifications()
        
        //When application loads, the badge counter should restart
        UIApplication.shared.applicationIconBadgeNumber = 0
    
        setAppLaunchTime()
        
        return true
    }
    
    func setAppLaunchTime() {
        
        DispatchQueue.main.async() { () -> Void in
            let appLaunchTime = CFAbsoluteTimeGetCurrent() - self.START_TIME
            UserDefaults.standard.set(appLaunchTime, forKey: self.APP_LAUNCH_TIME_KEY)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

