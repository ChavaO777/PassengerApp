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
	
    public var bComesfromNotification = Bool()
    
    //Colors used in the buttons selection and unselection
    
    private static let BUTTON_SELECTED_BKG_COLOR = UIColor(red: 134.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    private static let BUTTON_SELECTED_TINT_COLOR = UIColor(red: 210/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    private static let BUTTON_UNSELECTED_BKG_COLOR = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    private static let BUTTON_UNSELECTED_TINT_COLOR = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
    
    //The office hours that the crafters are in service, in 24h format
    private static let LATEST_OFFICE_HOUR = 20
    private static let EARLIEST_OFFICE_HOUR = 7
    
    
	/*
	This value is either passed by `TripTableViewController` in `prepare(for:sender:)`
	or constructed as part of adding a new trip.
	*/
	var trip: Trip?
    
    var triggeredBySegue = String()
    var indexFromTrip = Int()
	
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
            
            //Remove the pending notification if any
            if trip.active
            {
                NotificationManager.cancelTripNotification(forTripName: trip.alarmName)
            }
            
        }
        else{
            //Initialize repetition days if creating a trip
            for _ in 0...6 {
                repetitionDays.append(false)
            }
        }
        
        
        //Prevent date picker from entering past times, considering max anticipation minutes
        let minutesAnt = UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE
        var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        dateComp.minute = dateComp.minute! + minutesAnt
        datePicker.minimumDate = Calendar.current.date(from: dateComp)!
        
        
        updateSaveButtonState()
        
        redrawButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
		
		// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
		//let isPresentingInAddTripMode = presentingViewController == navigationController//is UINavigationController
        
        let isPresentingInAddTripMode = triggeredBySegue == "addTripSegue"
        
		if isPresentingInAddTripMode {
			//dismisses the modal scene and animates the transition back to the previous scene
			dismiss(animated: true, completion: nil)
			// neither the prepare(for:sender:) method nor the unwind action method are called.

		}
		else if let owningNavigationController = navigationController{
            //pops the closest navigation controller and presents the resulting view
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
		
        trip = createTripFromInputData(name: alarmNameTextField.text!, date: datePicker.date, repetitionDays: repetitionDays)
		
        //Check the date and time is valid
        if (!isValidDateTime(date: datePicker.date))
        {
            let eh = TripViewController.EARLIEST_OFFICE_HOUR
            let lh = TripViewController.LATEST_OFFICE_HOUR
            
            presentTripErrorAlert (message: )
            //when the user wants to re-edit his trip, prevent the segue from happening
            return false
        }
        
		//Check if this view was called to add a new trip and not to edit one
        let isPresentingInAddTripMode = triggeredBySegue == "addTripSegue"
    
		if isPresentingInAddTripMode
		{
			//if we are adding a new trip, check if there is already a trip with the same values
			if let message = checkForTripRepetition ()
			{
                
                presentTripErrorAlert (message: message)
				//when the user wants to re-edit his trip, prevent the segue from happening
				return false
			}
		}
		
		return true
	}
	
    //Presents an alert to the user, when a trip cannot be added or edited correctly
    //The user can chose to go back an edit the trip, or discard and go back to the trip list
    func presentTripErrorAlert (message: String)
    {
        //If it is, ask the user for an action
        let alert = UIAlertController(title: "Alerta",
                                      message: message,
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
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //trip could be added/edited succesfully, make a notification for it
        NotificationManager.createTripNotification(tripName: trip!.alarmName, tripDepartureTime: trip!.departureTime, tripDate: trip!.alarmDate)
    }

	
	//When the user touches a day button, change its colors and toggle its state
    @IBAction func toggleRepetition(_ sender: Any) {
        let button = sender as! UIButton
        
        repetitionDays[button.tag] = !repetitionDays[button.tag]
        
        redrawButtons()
    }
    
    //Checks that the trip date is inside office hours, not in the past, and considering anticipation minutes
    func isValidDateTime(date: Date) -> Bool
    {
        if (date < Date())
        {
            return "No se pueden agendar fechas en el pasado"
        }
        
        var currentDateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        let anticipation = (UserConfiguration.getConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY)) as Any!
        let minutes = anticipation as! Int
        currentDateComp.minute = currentDateComp.minute! + minutes
        
        
        if (date <= Calendar.current.date(from: currentDateComp))
        {
            return "Por tu configuración, "
        }
        
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        //Verify office hours
        if (dateComp.hour! >= TripViewController.LATEST_OFFICE_HOUR)
        {
            return "No se puede agendar un traslado fuera de las horas de trabajo (\(eh):00-\(lh):00)"
        }
        else if dateComp.hour! < TripViewController.EARLIEST_OFFICE_HOUR
        {
            return "No se puede agendar un traslado fuera de las horas de trabajo (\(eh):00-\(lh):00)"
        }
        
        return nil
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
	
    //To allow the user to stop focusing on the text field
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		alarmNameTextField.resignFirstResponder()
		return true
	}
		
	/*Checks whether the current trip saved in the instance is already present in the stored trips
		Returns a string specifying which criteria a repeated trip infringed
        If there was no repeating trip, it returns nil
		A trip is considered equal to another if the departure time is the same and (the repetition days are the same or they have the same date). Trips must have a unique name
	*/
    func checkForTripRepetition() -> String?
	{
        //Load trips
		let trips = Trip.loadTrips()
		
		//If there are no trips, it clearly is not repeating
		if trips == nil || trips!.count == 0
		{
			return nil
		}
        
        //Check trips
		for t in trips!
		{
            //If a trip already has that name
            if t.alarmName == trip!.alarmName
            {
                return "Ya existe un traslado con el mismo nombre."
            }
            
			//if the departure time is the same
			if t.departureTime == trip!.departureTime
			{
				//If they both have at least 1 day of repetition
				if t.hasRepetionDay() && trip!.hasRepetionDay()
				{
					//Check if they are the same
					if t.getRepetitionDaysAsString() == trip!.getRepetitionDaysAsString()
					{
						return "Ya existe un traslado a la misma hora y con los mismos días repetidos."
					}
				}
				//If only one has a repeated day, they cannot be equal, keep checking
				else if (t.hasRepetionDay() && !(trip!.hasRepetionDay())) || (!t.hasRepetionDay() && trip!.hasRepetionDay())
				{
					continue
				}
				//Otherwise, check for the same departure date
                else if Calendar.current.isDate(t.alarmDate, equalTo: trip!.alarmDate, toGranularity: .minute){
					return "Ya existe un traslado a la misma hora y con la misma fecha."
				}
			}
		}
		return nil
	}
	
    //Fills this VC's trip field with the data from the user
    func createTripFromInputData(name: String, date: Date, repetitionDays: [Bool]) -> Trip? {
        //Retrieve inputed data
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_mx")
        formatter.dateFormat = "HH:mm"
        let departureTime = formatter.string(from: date)
        
        // Set the trip to be passed to TripTableViewController after the unwind segue.
        return Trip(alarmName: name, repetitionDays: repetitionDays, departureTime: departureTime, alarmDate: date, active: true)
    }
    
    //Allows saving only if the trip name is not empty
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
