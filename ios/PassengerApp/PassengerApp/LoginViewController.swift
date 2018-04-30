//
//  LoginViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 3/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let PASSENGER_KEY = "passenger"
    let TOKEN_KEY = "token"
    let EXPIRATION_TIME_KEY = "expiration_time"
    
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        //If the username and/or the password are missing
        if credentialsAreEmpty () {
            
            //The authentication failed!
            let message = "Para autenticarse debe proporcionar su nombre de usuario y contraseña."
            alertAboutFailedAuthentication(message: message)
            return
        }
        
        else{
            
            let userIdText = userId.text
            let userPasswordText = userPassword.text
            
            var parameters = [String: String]()
            parameters["id"] = userIdText
            parameters["password"] = userPasswordText
            
            HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: handleLoginResponse)
        }
    }
    
    private func credentialsAreEmpty() -> Bool {
        
        let userIdText = userId.text
        let userPasswordText = userPassword.text
        
        return (userIdText?.isEmpty)! || (userPasswordText?.isEmpty)!
    }
    
    private func handleLoginResponse(data: Data?) -> Void {
        
        //Decode the response to the login call
        let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        
        //If the token is present, the login was successful.
        if loginResponseDictionary![TOKEN_KEY] != nil {
        
            print("Successful login!")
            //Store the id, token and expiration time
//                storePassengerData(loginResponseDictionary: loginResponseDictionary)
            
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{ //If the login failed, send an alert
            
            let message = "El usuario y/o la contraseña son incorrectos."
            alertAboutFailedAuthentication(message: message)
        }
    }
    
    private func storePassengerData(loginResponseDictionary: [String: Any]) -> Void {
        
        //Store the passenger data (but not the password) in the UserDefaults
        UserDefaults.standard.set(loginResponseDictionary[PASSENGER_KEY], forKey: PASSENGER_KEY)
        UserDefaults.standard.set(loginResponseDictionary[TOKEN_KEY], forKey: TOKEN_KEY)
        UserDefaults.standard.set(loginResponseDictionary[EXPIRATION_TIME_KEY], forKey: EXPIRATION_TIME_KEY)
    }
    
    private func alertAboutFailedAuthentication(message: String) {
        
        //If it is, ask the user for an action
        let alert = UIAlertController(title: "Alerta",
                                      message: message,
                                      preferredStyle: .alert)
        
        // Discard current trip button
        let okAction = UIAlertAction(title: "Ok.", style: .default, handler: { (action) -> Void in
            // Go back to login
            self.dismiss(animated: true, completion: nil)
        })
        
        // Add action buttons and present the Alert
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

