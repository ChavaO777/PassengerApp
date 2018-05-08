//
//  TripTableViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/16/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import os.log

class TripTableViewController: UITableViewController, InteractiveTableViewCellDelegate {

    //MARK: Properties
    
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved trips
        if let savedTrips = Trip.loadTrips() {
            trips += savedTrips
            os_log("Trips successfully loaded.", log: OSLog.default, type: .debug)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    //Prepares and returns the data for the current cell to be drawn
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Retrieve current table view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell", for: indexPath) as? TripTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TripTableViewCell.")
        }
        
        //This controller is the delegate for all its table view cells
        cell.cellDelegate = self
        cell.currentIndexPath = indexPath.row //The cell must know its current row index
        
        //Retrieve the corresponding trip on that index
        let trip = trips[indexPath.row]
        
        //Fill in data for the cell
        
        cell.alarmName.text = trip.alarmName
        
        if trip.hasRepetionDay()
        {
            //If the trip has at least 1 repetition day, present the information of all the days
            cell.repetitionDaysLabel.text = trip.getRepetitionDaysAsString()
        }
        else{
            //If not, present the date of the trip alarm
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "es_MX")
            //formatter.dateFormat = "EEEEE d, MMM yyyy"
            let someDateTime = formatter.string(from: trip.alarmDate)
            
            cell.repetitionDaysLabel.text = someDateTime
        }
        
        cell.departureTime.text = trip.departureTime
        
        cell.active.setOn(trip.active, animated: false)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                
        if editingStyle == .delete {
            
            //Delete trip's notification upon deletion
            let trip = trips[indexPath.row]
            NotificationManager.cancelTripNotification(forTripName: trip.alarmName)
            
            // Delete the row from the data source
            trips.remove(at: indexPath.row)
            Trip.saveTrips(trips)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - InteractiveTableViewCellDelegate methods
    
    func didTapCell(_ cell: UITableViewCell, cellForRowAt rowIndex: Int?) {
    
        //Get trip in question
        let trip = trips[rowIndex!]
        
        //toggle its active value, when the switch is flipped on the table view cell
        trip.active = !(trip.active)
        
        //If the trip was deactivated and became active, create notification
        if (trip.active)
        {
            NotificationManager.createTripNotification(tripName: trip.alarmName, tripDepartureTime: trip.departureTime, tripDate: trip.alarmDate)
        }
        else
        {
            //Otherwise, cancel notification
            NotificationManager.cancelTripNotification(forTripName: trip.alarmName)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //Check that the target VC is the TripViewController
        if let targetViewController = segue.destination as? TripViewController
        {
            //Indicate it which segue is presenting it
            targetViewController.triggeredBySegue = segue.identifier!
        }
        else { //if failed
            //See if the target is a NavController
            guard let navController = segue.destination as? UINavigationController,
            let targetViewController = navController.viewControllers.first as? TripViewController
            else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            //If it is and its child is the TripViewController, do the same as above
            targetViewController.triggeredBySegue = segue.identifier!
        }
        
        
        switch(segue.identifier ?? "") {
            //If the segue preparing is that of addition, just log
            case "addTripSegue":
                os_log("Adding a new trip.", log: OSLog.default, type: .debug)
            
            //If it is to edit/see detail
            case "ShowDetail":
                
                guard let tripDetailViewController = segue.destination as? TripViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //Get the cell that triggered the segue
                guard let selectedTripCell = sender as? TripTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                //Get its index
                guard let indexPath = tableView.indexPath(for: selectedTripCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                //Retrieve trip object
                let selectedTrip = trips[indexPath.row]
                //Pass trip to the trip detail controller
                tripDetailViewController.trip = selectedTrip
            
            //Loads a particular trip from its notification
            case "loadTripSegue":
            
                print("Loading segue from trip notification...")
            
                guard let tripDetailViewController = segue.destination as? TripViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                //Get trip from caller, it must exist if it had a notification
                let trip = sender as! Trip
                
                //Pass trip to the trip detail controller
                tripDetailViewController.trip = trip
                
                let tripIndex = findIndexFromTrip (trip)
                
                //Save index
                tripDetailViewController.indexFromTrip = tripIndex
            
                /*
                 * indicate that the TripViewController comes from a notification loading,
                 * so we avoid adding a new trip on return
                 */
                tripDetailViewController.bComesfromNotification = true
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    //Returns the index of the trip array where the particular trip can be found
    func findIndexFromTrip (_ trip: Trip) -> Int
    {
        for i in 0..<trips.count
        {
            if trips[i].equals(trip)
            {
                return i
            }
        }
        return -1
    }
    
    //MARK: Actions
    
    //Called when a view controller calls back to this controller
    @IBAction func unwindToTripList(sender: UIStoryboardSegue) {
        
        //If the caller for this VC is the TripViewController with a valid Trip instance,
        if let sourceViewController = sender.source as? TripViewController, let trip = sourceViewController.trip {
            
            //checks whether a row in the table view is selected.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // if so, update an existing trip.
                trips[selectedIndexPath.row] = trip
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                
                NotificationManager.createMessageNotification(message: "Trip \"\(trip.alarmName)\" was edited!")
            }
            //If the trip view comes from a notification, we are definetely not adding a new trip
            else if sourceViewController.bComesfromNotification
            {
                //Yet if we clicked save, the trip should be updated, the previous one should cease to exist
                
                if (sourceViewController.indexFromTrip >= 0)
                {
                    trips.remove (at: sourceViewController.indexFromTrip)
                }
                
                //But add new trip
                trips.append(trip)
                
                //Reset flag
                sourceViewController.bComesfromNotification = false
                
                NotificationManager.createMessageNotification(message: "Trip \"\(trip.alarmName)\" was edited!")
            }
            else
            {
                //Add new trip otherwise
                let newIndexPath = IndexPath(row: trips.count, section: 0)
                trips.append(trip)
                
                //Draw new cell
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                NotificationManager.createMessageNotification(message: "Trip \"\(trip.alarmName)\" was added!")

            }
            
            //Save changes
            Trip.saveTrips(trips)
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadTestTrips() {
        
        //2 sample trips
        var boolArr1 = [Bool]()
        boolArr1 += [true, true, false, false, false, false, true]
        
        guard let trip1 = Trip(alarmName: "Test Alarm1", repetitionDays: boolArr1, departureTime: "16:09", alarmDate: Date(), active: true)
            else { fatalError("Can't create trip1")}
        
        var boolArr2 = [Bool]()
        boolArr2 += [false, false, false, false, false, false, false]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let t_date = formatter.date(from: "2018/05/08 22:31")
        
        guard let trip2 = Trip(alarmName: "Test Alarm2", repetitionDays: boolArr2, departureTime: "22:31", alarmDate: t_date!, active: false)
            else { fatalError("Can't create trip2")}
        
        trips += [trip1, trip2]
    }
    
}
