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

    
    @IBAction func createReviewPopUp(_ sender: Any) {
        
        //Create popup for new trip data
        let reviewVC = UIStoryboard (name: "Main" /*same story board, different view/scene */, bundle: nil).instantiateViewController(withIdentifier: "ReviewView") as! ReviewViewController
        
        self.addChildViewController(reviewVC)
        reviewVC.view.frame = self.view.frame
        self.view.addSubview(reviewVC.view)
        reviewVC.didMove(toParentViewController: self)
    }

}

