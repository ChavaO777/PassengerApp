//
//  LoginViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 3/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: UIButton) {
    
        //If the username and/or the password are missing
        if credentialsAreEmpty ()
        {
            //If it is, ask the user for an action
            let alert = UIAlertController(title: "Alerta",
                                          message: "Para autenticarse, debe proporcionar su nombre de usuario y contraseña.",
                                          preferredStyle: .alert)
            
            // Discard current trip button
            let okAction = UIAlertAction(title: "Ok.", style: .default, handler: { (action) -> Void in
                // Go back to login
                self.dismiss(animated: true, completion: nil)
            })
            
            // Add action buttons and present the Alert
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            //The authentication failed!
            return
        }
    }
    
    private func credentialsAreEmpty() -> Bool {
        
        let usernameText = username.text
        let passwordText = password.text

        return (usernameText?.isEmpty)! || (passwordText?.isEmpty)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

