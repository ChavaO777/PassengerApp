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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        let t_date = formatter.date(from: "2017/05/08 22:31")
        
        guard let trip2 = Trip(alarmName: "Test Alarm2", repetitionDays: boolArr2, departureTime: "21:45", alarmDate: t_date!, active: true)
        else { fatalError("Can't create trip2")}
        
        trips += [trip1, trip2]
    }
    
}
