//
//  TripViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import os.log

//View Controller that handles the add/edit screen for a single trip
class TripViewController: UIViewController, UITextFieldDelegate {
	
    //Colors used in the buttons selection and unselection
    
    private static let BUTTON_SELECTED_BKG_COLOR = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    private static let BUTTON_SELECTED_TINT_COLOR = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    private static let BUTTON_UNSELECTED_BKG_COLOR = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    private static let BUTTON_UNSELECTED_TINT_COLOR = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    
    
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
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!

    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
		
		// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
		let isPresentingInAddTripMode = presentingViewController is UINavigationController
		
		if isPresentingInAddTripMode {
			//dismisses the modal scene and animates the transition back to the previous scene
			dismiss(animated: true, completion: nil)
			// neither the prepare(for:sender:) method nor the unwind action method are called.

		}
		else if let owningNavigationController = navigationController{
			owningNavigationController.popViewController(animated: true)
		}
		else {
			fatalError("The TripViewController is not inside a navigation controller.")
		}
    }
	
	/*
	When clicking on the save button, this view controller builds its trip object,
	based on the current information, for it to be visible for the destination view controller
	*/
	override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool
	{
		// Configure the destination view controller only when the save button is pressed.
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
			return false
		}
		
		//Retrieve inputted data
		let alarmName = alarmNameTextField.text ?? ""
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "es_mx")
		formatter.dateFormat = "HH:mm"
		let departureTime = formatter.string(from: datePicker.date)
		
		// Set the trip to be passed to TripTableViewController after the unwind segue.
		trip = Trip(alarmName: alarmName, repetitionDays: repetitionDays, departureTime: departureTime, alarmDate: datePicker.date, active: true)
		
		
		//Check if this view was called to add a new trip and not to edit one
		let isPresentingInAddTripMode = presentingViewController is UINavigationController
		
		if isPresentingInAddTripMode
		{
			//if we are adding a new trip, check if there is already a trip with the same values
			if checkForRepeatedTrip ()
			{
				//If it is, ask the user for an action
				let alert = UIAlertController(title: "Alerta",
											  message: "Ya existe un traslado con la hora y fecha establecidos",
											  preferredStyle: .alert)
				
				// Discard current trip button
				let discardAction = UIAlertAction(title: "Descartar", style: .default, handler: { (action) -> Void in
					// Leave the current trip, go back to the trip list screen
					self.dismiss(animated: true, completion: nil)
					// neither the prepare(for:sender:) method nor the unwind action method are called, so it won´t save the trip
				})
				// Cancel button
				let cancel = UIAlertAction(title: "Editar", style: .cancel, handler: { (action) -> Void in })
				
				
				// Add action buttons and present the Alert
				alert.addAction(discardAction)
				alert.addAction(cancel)
				present(alert, animated: true, completion: nil)
				
				//when the user wants to reedit his trip, prevent the segue from happening
				return false
			}
		}
		
		return true
	}
	
    // This method lets you configure a view controller before it's presented.
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Handle the text field’s user input through delegate callbacks.
		alarmNameTextField.delegate = self
		
		
		//The trip property will only be non-nil when an existing trip is being edited.
		if let trip = trip {
			
			//Alarm name
			navigationItem.title = trip.alarmName
			alarmNameTextField.text = trip.alarmName
			
			//Alarm Date
			datePicker.date = trip.alarmDate
			
			//Repetition days
			repetitionDays = trip.repetitionDays
			
		}
		else{
			//Initialize repetition days if creating a trip
			for _ in 0...6 {
				repetitionDays.append(false)
			}
		}
		
		updateSaveButtonState()
        
        redrawButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	
	//When the user touches a day button, change its colors and toggle its state
    @IBAction func toggleRepetition(_ sender: Any) {
        let button = sender as! UIButton
        
        repetitionDays[button.tag] = !repetitionDays[button.tag]
        
        redrawButtons()
    }
    
    //MARK: UITextFieldDelegate
	
	//Disable saving while in mid-edit
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// Disable the Save button while editing.
		saveButton.isEnabled = false
	}
	
	//Check if should be reenabled when something has being introduced
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState()
		navigationItem.title = textField.text
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		alarmNameTextField.resignFirstResponder()
		return true
	}
	
	//MARK: Private Methods
	
	/*Checks whether the current trip saved in the instance is already present in the stored trips
		Returns true if it found a repeated trip, false otherwise.
		A trip is considered equal to another if the departure time is the same and (the repetition days are the same or they have the same date)
		It takes in a boolean, to indicate that if a trip is found to be repeated, it should be deleted right there
	*/
	private func checkForRepeatedTrip() -> Bool
	{
		let trips = Trip.loadTrips()
		
		//If there are no trips, it clearly is not repeating
		if trips != nil || trips?.count == 0
		{
			return false
		}
		
		for t in trips!
		{
			//if the departure time is the same
			if t.departureTime == trip!.departureTime
			{
				//If they both have at least 1 day of repetition
				if t.hasRepetionDay() && trip!.hasRepetionDay()
				{
					//Check if they are the same
					if t.getRepetitionDaysAsString() == trip!.getRepetitionDaysAsString()
					{
						return true
					}
				}
				//If only one has a repeated day, they cannot be equal, keep checking
				else if (t.hasRepetionDay() && !trip!.hasRepetionDay()) || (t.hasRepetionDay() && trip!.hasRepetionDay())
				{
					continue
				}
				//Otherwise, check for the same departure date
				else if t.alarmDate == trip!.alarmDate{
					return true
				}
			}
		}
		return false
	}
	
	private func updateSaveButtonState() {
		// Disable the Save button if the text field is empty.
		let text = alarmNameTextField.text ?? ""
		saveButton.isEnabled = !text.isEmpty
	}
	
	
    private func changeButtonColors (button: UIButton, bkgColor: UIColor, tintColor: UIColor)
    {
        button.backgroundColor = bkgColor
        button.tintColor = tintColor
    }
    
    private func redrawButtons()
    {
        if repetitionDays[0]
        {
            changeButtonColors(button: mondayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
        }
        else{
			changeButtonColors(button: mondayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
        }
		
		if repetitionDays[1]
		{
			changeButtonColors(button: tuesdayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
            
        }
		else{
			changeButtonColors(button: tuesdayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
		
		if repetitionDays[2]
		{
			changeButtonColors(button: wednesdayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
		}
		else{
			changeButtonColors(button: wednesdayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
		
		if repetitionDays[3]
		{
			changeButtonColors(button: thursdayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
		}
		else{
			changeButtonColors(button: thursdayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
		
		if repetitionDays[4]
		{
			changeButtonColors(button: fridayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
		}
		else{
			changeButtonColors(button: fridayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
		
		if repetitionDays[5]
		{
			changeButtonColors(button: saturdayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
		}
		else{
			changeButtonColors(button: saturdayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
		
		if repetitionDays[6]
		{
			changeButtonColors(button: sundayButton, bkgColor: TripViewController.BUTTON_SELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_SELECTED_TINT_COLOR)
		}
		else{
			changeButtonColors(button: sundayButton, bkgColor: TripViewController.BUTTON_UNSELECTED_BKG_COLOR, tintColor: TripViewController.BUTTON_UNSELECTED_TINT_COLOR)
		}
    }
}
