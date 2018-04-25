//
//  ProfileViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    var notifications = true
    var vibration = true
    var sound = true
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        
        notifications = sender.isOn
        print("notifications = " + String(notifications))
        
//        //Path to the ConfigVariables plist file
//        let path = Bundle.main.path(forResource: "ConfigVariables", ofType: "plist")
//        //Dictionary with the key-value structures in that file
//        let dict = NSDictionary(contentsOfFile: path!)
//
//        dict?.setValue(notifications, forKey: "notifications")
//        
//        if let path = Bundle.main.path(forResource:"ConfigVariables", ofType: "plist"),
//            FileManager.default.fileExists(atPath: path),
//            
//            let dict = NSArray(contentsOfFile: path) as? [NSMutableDictionary] {
//            
//                let notificationsValue = dic["notifications"]
////                let selectedAnimal = dic[selectedIndex]
////                selectedAnimal["fav"] = isFavorite // this replaces `setValue`
//                (dict as NSArray).write(toFile: path, atomically: true)
//            }
    }
    
    @IBAction func toggleVibration(_ sender: UISwitch) {
        
        vibration = sender.isOn
        print("vibration = " + String(vibration))
    }
    
    @IBAction func toggleSound(_ sender: UISwitch) {
        
        sound = sender.isOn
        print("sound = " + String(sound))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Get the values from the ConfigVariables plist file
        getValueFromPlist(keyName: "notifications")
        getValueFromPlist(keyName: "vibration")
        getValueFromPlist(keyName: "sound")
        
        notificationsSwitch.setOn(notifications, animated: false)
        vibrationSwitch.setOn(vibration, animated: false)
        soundSwitch.setOn(sound, animated: false)
        
        print(notifications)
        print(vibration)
        print(sound)
    }
    
    func getValueFromPlist(keyName: String){
        
        //Path to the ConfigVariables plist file
        let path = Bundle.main.path(forResource: "ConfigVariables", ofType: "plist")
        //Dictionary with the key-value structures in that file
        let dict = NSDictionary(contentsOfFile: path!)
        
        //Get the value of the key 'keyName'
        switch keyName {
        
            case "notifications":
                //If the value in the plist is 1, then set the variable as true. Else, as false.
                notifications = dict?.value(forKeyPath: keyName) as! Int == 1 ? true : false
                break
            
            case "vibration":
                //If the value in the plist is 1, then set the variable as true. Else, as false.
                vibration = dict?.value(forKeyPath: keyName) as! Int == 1 ? true : false
                break
            
            case "sound":
                //If the value in the plist is 1, then set the variable as true. Else, as false.
                sound = dict?.value(forKeyPath: keyName) as! Int == 1 ? true : false
                break
        default:
            
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
