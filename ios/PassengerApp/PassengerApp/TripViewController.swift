//
//  TripViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import os.log

class TripViewController: UIViewController {
	
	/*
	This value is either passed by `TripTableViewController` in `prepare(for:sender:)`
	or constructed as part of adding a new trip.
	*/
	var trip: Trip?
	
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var repetitionDays: [Bool] = []
    
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var alarmNameTextField: UITextField!
	
	@IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //Retrieve inputted data
        let alarmName = alarmNameTextField.text ?? "Nueva alarma"
        
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "es_mx")
         formatter.dateFormat = "HH:mm"
         let departureTime = formatter.string(from: datePicker.date)
    
        // Set the trip to be passed to TripTableViewController after the unwind segue.
        trip = Trip(alarmName: alarmName, repetitionDays: repetitionDays, departureTime: departureTime, alarmDate: datePicker.date, active: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        //self.showAnimate()
        
        //Initializes array of bools to each day
        for _ in 0...6 {
            repetitionDays.append(false)
        }
        
        redrawButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func toggleRepetition(_ sender: Any) {
        let button = sender as! UIButton
        
        repetitionDays[button.tag] = !repetitionDays[button.tag]
        
        redrawButtons()
    }
    
    
    /*
     //To CLOSE OP-UP View
    func closePopup()
    {
        self.removeAnimate()
    }
    
    
    //CODE to create a popup from a view
     //Create popup for new trip data
     let addTripVC = UIStoryboard (name: "Main" /*same story board, different view/scene */, bundle: nil).instantiateViewController(withIdentifier: "addTripView") as! TripViewController
     
     self.addChildViewController(addTripVC)
     addTripVC.view.frame = self.view.frame
     self.view.addSubview(addTripVC.view)
     addTripVC.didMove(toParentViewController: self)
 
     
    //Pop up aimation
    func showAnimate()
    {
        self.view.transform = self.view.transform.scaledBy(x: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1.0
            self.view.transform = self.view.transform.scaledBy(x: 1.0, y: 1.0)
        })
    }
    
     
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = self.view.transform.scaledBy(x: 1.3, y: 1.3)
        }, completion: {(finished : Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        })
    }
 */
    
    func redrawButtons()
    {
        if repetitionDays[0]
        {
			mondayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			mondayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
        }
        else{
			mondayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			mondayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
        }
		
		if repetitionDays[1]
		{
			tuesdayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			tuesdayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			tuesdayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			tuesdayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		
		if repetitionDays[2]
		{
			wednesdayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			wednesdayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			wednesdayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			wednesdayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		
		if repetitionDays[3]
		{
			thursdayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			thursdayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			thursdayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			thursdayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		
		if repetitionDays[4]
		{
			fridayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			fridayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			fridayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			fridayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		
		if repetitionDays[5]
		{
			saturdayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			saturdayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			saturdayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			saturdayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		
		if repetitionDays[6]
		{
			sundayButton.backgroundColor = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
			sundayButton.tintColor = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
		else{
			sundayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			sundayButton.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
		}
    }
}
