//
//  ProfileViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var notifications = true
    var vibration = true
    var sound = true
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
    }
    
    @IBAction func toggleVibrations(_ sender: UISwitch) {
    }
    
    @IBAction func toggleSound(_ sender: UISwitch) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Get the values from the ConfigVariables plist file
        getValueFromPlist(keyName: "notifications")
        getValueFromPlist(keyName: "vibration")
        getValueFromPlist(keyName: "sound")
        
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
                notifications = dict?.value(forKeyPath: keyName) as! Int == 1 ? true : false
                break
            
            case "vibration":
                vibration = dict?.value(forKeyPath: keyName) as! Int == 1 ? true : false
                break
            
            case "sound":
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
