//
//  TripVCTests.swift
//  PassengerAppTests
//
//  Created by Comonfort on 5/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
import UIKit
@testable import PassengerApp

class TripVCTests: XCTestCase {
    
    var tripVC: TripViewController?;
    
    override func setUp() {
        super.setUp()
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tripVC =  mainStoryboard.instantiateViewController(withIdentifier: "TripView") as! TripViewController
    }
    
    override func tearDown() {
        super.tearDown()
        
        tripVC = nil
    }
    
    /*
     * Test ID:
     * Tests that a day in the past is invalid
     */
    func testPastDate() {
        let pastDate = getDateFromString(dateStr: "2018-02-02 00:00")
        XCTAssert(!tripVC!.isValidDateTime(date: pastDate))
    }
    
    /*
     * Test ID:
     * Tests that the time is at the beginning of office hours
     */
    func testBeginOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 7:00")
        XCTAssert(tripVC!.isValidDateTime(date: pastDate))
    }
    
    /*
     * Test ID:
     * Tests that the time is at the beginning of office hours
     */
    func testBeforeBeginOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 6:59")
        XCTAssert(!tripVC!.isValidDateTime(date: pastDate))
    }

    
    
    func getDateFromString(dateStr: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: dateStr)!
    }
 
    
    
    
    
}
