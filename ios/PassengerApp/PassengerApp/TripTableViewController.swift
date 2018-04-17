//
//  TripTableViewController.swift
//  PassengerApp
//
//  Created by Comonfort on 4/16/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class TripTableViewController: UITableViewController {

    //MARK: Properties
    
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadTrips()
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //Retrieve current table view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell", for: indexPath) as? TripTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TripTableViewCell.")
        }
        
        //Retrieve the corresponding trip on that index
        let trip = trips[indexPath.row]
        
        //Fill in data for the cell
        
        cell.alarmName.text = trip.alarmName
        
        if hasRepetionDay(repetitionDays: trip.repetitionDays)
        {
            //If the trip has at least 1 repetition day, present the information of all the days
            cell.repetitionDaysLabel.text = getRepetitionDaysAsString(repetitionDays: trip.repetitionDays)
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
    
    //Checks that the array of repetition days, has at least one of them as true
    private func hasRepetionDay(repetitionDays: [Bool]) -> Bool
    {
        for i in 0...repetitionDays.count - 1
        {
            if (repetitionDays[i])
            {
                return true
            }
        }
        return false
    }
    
    private func getRepetitionDaysAsString(repetitionDays: [Bool]) -> String
    {
        var str = String("")
        
        let daysLetters = ["L", "M", "M", "J", "V", "S", "D"]
        
        for i in 0...repetitionDays.count - 1
        {
            if (repetitionDays[i])
            {
                str.append(daysLetters[i])
                
            }
            else
            {
                str.append("-")
            }
            
            if (i != repetitionDays.count - 1)
            {
                str.append(" ")
            }
        }
        
        return str
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Private Methods
    
    private func loadTrips() {
        
        //2 sample trips, reeplace by reading data from the plist
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
