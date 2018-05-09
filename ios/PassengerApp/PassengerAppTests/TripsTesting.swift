//
//  TripsTesting.swift
//  PassengerAppTests
//
//  Created by Comonfort on 5/5/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
import UIKit
@testable import PassengerApp

class TripsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        //Over-write saved trips array with an empty one, to make sure trips do not interfere between tests
        Trip.saveTrips([Trip]())
    }
    
    /*
     * TEST ID: 1.1
     * Tests that a trip is not created if there is no name for it. The trip constructor should return nil
     */
    func testNoTripName(){
        let trip = Trip(alarmName: "", repetitionDays: [true, false, false, true, false, false, false], departureTime: "16:34", alarmDate: Date(), active: true )
        
        XCTAssert(trip == nil)
    }
    
    /*
     * TEST ID: 1.2
     * Tests that a trip is not created if the array of repetition days is less than 7. The trip constructor should return nil
     */
    func testNotEnoughRepetitionDays(){
        let trip = Trip(alarmName: "My trip", repetitionDays: [ false, false, true, false, false, false], departureTime: "16:34", alarmDate: Date(), active: true )
        
        XCTAssert(trip == nil)
    }
    
    /*
     * TEST ID: 1.3
     * Tests that a trip is not created if the array of repetition days is greater than 7. The trip constructor should return nil
     */
    func testMoreRepetitionDays(){
        let trip = Trip(alarmName: "My trip", repetitionDays: [ true, true, false, false, true, false, false, false], departureTime: "16:34", alarmDate: Date(), active: true )
        
        XCTAssert(trip == nil)
    }
    
    /*
     * TEST ID: 1.4
     * Tests that a trip is not created if the departure time string is empty. The trip constructor should return nil
     */
    func testNoDepartureTime(){
        let trip = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false], departureTime: "", alarmDate: Date(), active: true )
        
        XCTAssert(trip == nil)
    }
    
    /*
     * TEST ID: 1.5
     * Tests that a trip is equal to another
     */
    func testTripEquals(){
        
        let tripsDate = Date()
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: tripsDate, active: true )!
        
        let trip2 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: tripsDate, active: true )!
        
        XCTAssert(trip1.equals(trip2))
    }
    
    /*
     * TEST ID: 1.6
     * Tests that a trip is equal to another but using the overriden "==" operator
     */
    func testTripEqualsOverride(){
        let tripsDate = Date()
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: tripsDate, active: true )!
        
        let trip2 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: tripsDate, active: true )!

        XCTAssert(trip1 == trip2)
    }
    
    /*
     * TEST ID: 1.7
     * Tests that an array of trips is saved and loaded correctly
     */
    func testCorrectLoadSave(){
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                        departureTime: "16:34", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, true, true, true, false, false],
                         departureTime: "21:04", alarmDate: Date(), active: true )!
        
        
        let trips = [trip1, trip2]
        
        Trip.saveTrips(trips)
        
        let tripsLoaded = Trip.loadTrips()!
        
        XCTAssert(trips.count == tripsLoaded.count)
        for i in 0..<tripsLoaded.count
        {
            XCTAssert(trips[i] == tripsLoaded[i])
        }
    }
    
    /*
     * TEST ID: 1.8
     * Tests that an empty array of trips is saved and loaded correctly
     */
    func testEmptyLoadSave(){
        
        var trips = [Trip]()
        
        Trip.saveTrips(trips)
        
        
        XCTAssert(trips == Trip.loadTrips()!)
    }
    
    /*
     * TEST ID: 1.9
     * Tests that a trip with a particular name is present in an array of trips
     */
    func testFindTrip(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, true, true, true, false, false],
                         departureTime: "21:04", alarmDate: Date(), active: true )!
        
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: Date(), active: true )!
        
        let trips = [trip1, trip2, trip3]
        Trip.saveTrips(trips)
        
        XCTAssert(trip3 == Trip.findTrip(withName: "I am a trip")!)
    }
    
    /*
     * TEST ID: 1.10
     * Tests that a trip with a particular name is not present in an array of trips
     */
    func testNotFindTrip(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, true, true, true, false, false],
                         departureTime: "21:04", alarmDate: Date(), active: true )!
        
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: Date(), active: true )!
        
        let trips = [trip1, trip2, trip3]
        Trip.saveTrips(trips)
        
        XCTAssert(Trip.findTrip(withName: "NotATrip") == nil)
    }
    
    /*
     * TEST ID: 1.11
     * Tests that a trip with a particular name is not present in an empty array of trips
     */
    func testEmptyFindTrip(){
        
        XCTAssert(Trip.findTrip(withName: "NotATrip") == nil)
    }
    
    /*
     * TEST ID: 1.12
     * Tests that the first day as repetition is recognized correctly
     */
    func testHasRepDayFirst(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, false, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.hasRepetionDay())
    }
    
    /*
     * TEST ID: 1.13
     * Tests that the last day as repetition is recognized correctly
     */
    func testHasRepDayLast(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [false, false, false, false, false, false, true],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.hasRepetionDay())
    }
    
    /*
     * TEST ID: 1.14
     * Tests that a day of repetition in the middle is recognized correctly
     */
    func testHasRepDayMiddle(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [false, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.hasRepetionDay())
    }
    
    /*
     * TEST ID: 1.15
     * Tests that all days are repetition, it should have same response as with only 1
     */
    func testHasAllRepDays(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, true, true, true, true, true, true],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.hasRepetionDay())
    }
    
    /*
     * TEST ID: 1.16
     * Tests that the no repetition day is recognized correctly
     */
    func testHasNoRepDay(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [false, false, false, false, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(!trip1.hasRepetionDay())
    }
    
    /*
     * TEST ID: 1.17
     * Tests that the repetition days is gotten correctly as string
     */
    func testRepDaysString(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, false, false, false, true],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.getRepetitionDaysAsString() == "L - - - - - D")
    }
    
    /*
     * TEST ID: 1.18
     * Tests that a trip with all the repetition days is gotten correctly as string
     */
    func testAllRepDaysString(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, true, true, true, true, true, true],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.getRepetitionDaysAsString() == "L M M J V S D")
    }
    
    /*
     * TEST ID: 1.19
     * Tests that a trip with no repetition days is gotten correctly as string
     */
    func testNoneRepDaysString(){
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [false, false, false, false, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(trip1.getRepetitionDaysAsString() == "- - - - - - -")
    }

    
}
