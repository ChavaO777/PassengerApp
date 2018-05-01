//
//  LoginViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 3/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * Action for the button to login
     */
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
            
            //Call the backend with the required parameters to try to login and handle the response later
            HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: handleLoginResponse)
        }
    }
    
    /**
     * Function to validate that the login credentials are not empty
     *
     * @returns True, if either credential is empty. Else, false.
     */
    private func credentialsAreEmpty() -> Bool {
        
        let userIdText = userId.text
        let userPasswordText = userPassword.text
        
        //If either is empty, return true
        return (userIdText?.isEmpty)! || (userPasswordText?.isEmpty)!
    }
    
    /**
     *  Function the handle the login response from the backend
     */
    private func handleLoginResponse(data: Data?) -> Void {
        
        //Decode the response to the login call
        let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        
        //If the token is present, the login was successful.
        if  loginResponseDictionary != nil && loginResponseDictionary![UserConfiguration.TOKEN_KEY] != nil {
        
            print("Successful login!")
            //Store the id, token and expiration time
            storePassengerData(loginResponseDictionary: loginResponseDictionary!)
            //Let the user in, i.e. move past the login view
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{ //If the login failed, send an alert
            
            let message = "El usuario y/o la contraseña son incorrectos."
            alertAboutFailedAuthentication(message: message)
        }
    }
    
    /**
     *  Function to store the logged-in passenger's data in the UserDefaults
     */
    private func storePassengerData(loginResponseDictionary: [String: Any]) -> Void {
        
        let passenger = loginResponseDictionary[UserConfiguration.PASSENGER_KEY]! as! Dictionary<String, AnyObject>
        
        let passengerId = passenger["id"]
        let passengerToken = loginResponseDictionary[UserConfiguration.TOKEN_KEY]
        let expirationTime = loginResponseDictionary[UserConfiguration.EXPIRATION_TIME_KEY]
        
        // Store the passenger data (but not the password) in the UserDefaults
        UserConfiguration.setConfiguration(key: UserConfiguration.PASSENGER_KEY, value: passengerId as Any)
        UserConfiguration.setConfiguration(key: UserConfiguration.TOKEN_KEY, value: passengerToken as Any)
        UserConfiguration.setConfiguration(key: UserConfiguration.EXPIRATION_TIME_KEY, value: expirationTime as Any)
    }
    
    /**
     *  Function to send alerts with a given message
     *
     *  @param message the message that will be displayed in the alert
     */
    private func alertAboutFailedAuthentication(message: String) {
        
        //Create an alert
        let alert = UIAlertController(title: "Alerta",
                                      message: message,
                                      preferredStyle: .alert)
        
        //The alert simply needs an 'Ok' button
        let okAction = UIAlertAction(title: "Ok.", style: .default, handler: { (action) -> Void in
            // Go back to login
            self.dismiss(animated: true, completion: nil)
        })
        
        //Add action buttons and present the Alert
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

