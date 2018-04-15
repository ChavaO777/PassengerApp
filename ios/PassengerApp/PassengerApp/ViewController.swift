//
//  ViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 3/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "showTripsSegue", sender: self)
    }
    
}

