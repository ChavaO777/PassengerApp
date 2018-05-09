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
        
        //Over-write saved trips array with an empty one, to make sure trips do not interfere between tests
        Trip.saveTrips([Trip]())
    }
    
    /*
     * Test ID:
     * Tests that a day in the past is invalid
     */
    func testPastDate() {
        let pastDate = getDateFromString(dateStr: "2018-02-02 00:00")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == "No se pueden agendar fechas en el pasado")
    }
    
    /*
     * Test ID:
     * Tests that a time that is at the beginning of office hours, is invalid
     */
    func testBeginOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 7:00")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == nil)
    }
    
    /*
     * Test ID:
     * Tests that a time that is just before the beginning of office hours, is invalid
     */
    func testBeforeBeginOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 6:59")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == "No se puede agendar un traslado fuera de las horas de trabajo (7:00-20:00)")
    }
    
    /*
     * Test ID:
     * Tests that a time that is at the end of office hours, is invalid
     */
    func testEndOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 20:00")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == "No se puede agendar un traslado fuera de las horas de trabajo (7:00-20:00)")
    }
    
    /*
     * Test ID:
     * Tests that a time that is jsut after the end of office hours, is invalid
     */
    func testAfterEndOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 20:01")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == "No se puede agendar un traslado fuera de las horas de trabajo (7:00-20:00)")
    }
    
    /*
     * Test ID:
     * Tests that a time between office hours, is valid
     */
    func testBetweenOfficeHour() {
        let pastDate = getDateFromString(dateStr: "2030-02-02 12:34")
        XCTAssert(tripVC!.checkValidDateTime(date: pastDate) == nil)
    }
    
    /*
     * Test ID:
     * Tests that adding a trip within X anticipation minutes from now, is invalid
     */
    func testAnticipationMinutesInvalid() {
        
        let previousMinutes = UserConfiguration.getAnticipationMinutes()
        
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: 3 as Any)
        
        let tripDate = Date().addingTimeInterval(120.0)
        
        XCTAssert(tripVC!.checkValidDateTime(date: tripDate) == "Por tu configuración, debes elegir una hora que considere los minutos de anticipación (3 min.) para tu traslado.")
        
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: previousMinutes as Any)
    }
    
    /*
     * Test ID:
     * Tests that adding a trip at exactly X minutes from now, is invalid. X should be the maximum allowed
     */
    func testAnticipationMinutesUpperBound() {
        
        let previousMinutes = UserConfiguration.getAnticipationMinutes()
        let targetMinutes = UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MAX_VALUE
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: targetMinutes as Any)
        
        var comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comp.minute = comp.minute! + targetMinutes
        comp.second = 0
        let tripDate = Calendar.current.date(from: comp)
        
        XCTAssert(tripVC!.checkValidDateTime(date: tripDate!) == "Por tu configuración, debes elegir una hora que considere los minutos de anticipación (\(targetMinutes) min.) para tu traslado.")
        
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: previousMinutes as Any)
    }
    
    /*
     * Test ID:
     * Tests that adding a trip at exactly X minutes from now, is invalid. X should be the minimum allowed
     */
    func testAnticipationMinutesLowerBound() {
        
        let previousMinutes = UserConfiguration.getAnticipationMinutes()
        let targetMinutes = UserConfiguration.DEFAULT_NOTIFICATION_ANTICIPATION_MINUTES_MIN_VALUE
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: targetMinutes as Any)
        
        var comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comp.minute = comp.minute! + targetMinutes
        comp.second = 0
        let tripDate = Calendar.current.date(from: comp)
        
        XCTAssert(tripVC!.checkValidDateTime(date: tripDate!) == "Por tu configuración, debes elegir una hora que considere los minutos de anticipación (\(targetMinutes) min.) para tu traslado.")
        
        UserConfiguration.setConfiguration(key: UserConfiguration.NOTIFICATION_ANTICIPATION_MINUTES_KEY, value: previousMinutes as Any)
    }
    
    /*
     * Test ID:
     * Tests that a trip is not found to be repeated, because there are no saved trips
     */
    func testRepeatedTripOnEmptyArray() {
        
        Trip.saveTrips([Trip]())
        
        let trip1: Trip = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:34", alarmDate: Date(), active: true )!
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip1) == nil)
    }
    
    /*
     * Test ID:
     * Tests that a trip is found to be repeated in an array of only itself
     */
    func testRepeatedTripFound() {
        
        let trip1: Trip = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                               departureTime: "16:34", alarmDate: Date(), active: true )!
        
        Trip.saveTrips([trip1])
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip1) == "Ya existe un traslado con el mismo nombre.")
    }
    
    /*
     * Test ID:
     * Tests that a trip is not found in an array of 3 other trips
     */
    func testTripNotRepeated() {
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, true, true, true, false, false],
                         departureTime: "21:04", alarmDate: getDateFromString(dateStr: "2030-02-02 12:34"), active: true )!
        
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "Trip not found", repetitionDays: [true, false, false, true, false, false, false],
                               departureTime: "16:38", alarmDate: getDateFromString(dateStr: "2030-02-05 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == nil)
    }
    
    /*
     * Test ID:
     * Tests that a trip name is found to be repeated even when the rest of the trip is different
     */
    func testTripNameRepeated() {
        
        let trip1 = Trip(alarmName: "My repeated trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, true, true, true, false, false],
                         departureTime: "21:04", alarmDate: getDateFromString(dateStr: "2030-02-02 12:34"), active: true )!
        
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "My repeated trip", repetitionDays: [true, false, false, true, true, true, false],
                               departureTime: "16:38", alarmDate: getDateFromString(dateStr: "2030-02-05 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == "Ya existe un traslado con el mismo nombre.")
    }
    
    /*
     * Test ID:
     * Tests that a trip is repeating days and departure time
     */
    func testTripRepeatedDaysAndDepartureTime() {
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-01 16:34"), active: true )!
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "My other trip", repetitionDays: [false, false, false, true, true, false, false],
                               departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-05 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == "Ya existe un traslado a la misma hora y con los mismos días repetidos.")
    }
    
    /*
     * Test ID:
     * Tests that a trip is repeating departure time but has no repeated days
     */
    func testTripRepeatedDepartureTimeUnrepeatedDays() {
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-01 16:34"), active: true )!
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "My other trip", repetitionDays: [false, false, false, false, false, false, false], departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-05 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == nil)
    }
    
    /*
     * Test ID:
     * Tests that a trip has same departure date but different time
     */
    func testTripRepeatedDateDiffTime() {
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-01 16:34"), active: true )!
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-01-01 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "My other trip", repetitionDays: [false, false, false, false, false, false, false], departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == nil)
    }
    
    /*
     * Test ID:
     * Tests that a trip has same departure date and time
     */
    func testTripRepeatedDateAndDepartureTime() {
        
        let trip1 = Trip(alarmName: "My trip", repetitionDays: [true, false, false, true, false, false, false],
                         departureTime: "16:33", alarmDate: Date(), active: true )!
        
        let trip2 = Trip(alarmName: "My backup trip", repetitionDays: [false, false, false, false, false, false, false],
                         departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-01 16:34"), active: true )!
        let trip3 = Trip(alarmName: "I am a trip", repetitionDays: [false, false, false, true, true, false, false],
                         departureTime: "21:54", alarmDate: getDateFromString(dateStr: "2030-02-05 12:34"), active: true )!
        
        let trip4: Trip = Trip(alarmName: "My other trip", repetitionDays: [false, false, false, false, false, false, false], departureTime: "12:34", alarmDate: getDateFromString(dateStr: "2030-02-01 12:34"), active: true )!
        
        Trip.saveTrips([trip1, trip2, trip3])
        
        
        XCTAssert(tripVC!.checkTripRepetition(trip: trip4) == "Ya existe un traslado a la misma hora y con la misma fecha.")
    }
    
    /*
     * Test ID:
     * Tests that the hour and minute is retrieved correctly from a date
     */
    func testHourMinuteFormat() {
        
        let date = getDateFromString(dateStr: "2030-02-01 16:34")
        
        
        XCTAssert(tripVC!.getHourMinute(fromDate: date) == "16:34")
    }
    
    
    func getDateFromString(dateStr: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: dateStr)!
    }
    
}
