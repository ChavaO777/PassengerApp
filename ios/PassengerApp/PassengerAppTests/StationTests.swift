//
//  StationTest.swift
//  PassengerAppTests
//
//  Created by Salvador Orozco Villalever on 5/7/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
@testable import PassengerApp

class StationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetMarkerSnippet() {
        
        let data = """
        {
            "id": 1,
            "name": "Estación 1",
            "lat": 19.129328,
            "lng": -98.262249,
            "waiting_people": 3,
            "next_crafter_arrival_time": 5.6,
            "next_crafter_id": "PNATUF7ARTYS456",
            "createdAt": "2018-05-02T15:49:27.620Z",
            "updatedAt": "2018-05-02T15:49:27.620Z",
            "next_crafter": {
                "id": "PNATUF7ARTYS456",
                "name": "Crafter 3",
                "lat": 19.127677,
                "lng": -98.253732,
                "isActive": true,
                "total_seats": 6,
                "occupied_seats": 6,
                "createdAt": "2018-05-02T15:49:27.603Z",
                "updatedAt": "2018-05-02T15:49:27.603Z"
        }
        """.data(using: .utf8)! // our data in native (JSON) format
        
        do{
            
            let myStation = try JSONDecoder().decode(Station.self, from: data) // Decoding our data
            let markerSnippet = myStation.getMarkerSnippet(waiting_people: myStation.getWaitingPeople(), next_crafter_arrival_time: myStation.getNextCrafterArrivalTime())
            XCTAssertEqual(markerSnippet, "Personas esperando una crafter: 3\nSiguiente crafter en: 5.6 min.")
            
        }catch let jsonError{
            
            print(jsonError)
        }
    }
    
    func testGetStationsFromServer() {
        
        let expectation = self.expectation(description: "Station retrieval from the server")
        
        //Call the backend with the required parameters to try to login and handle the response later
        HTTPHandler.makeHTTPRequest(route: Station.ROUTE, httpMethod: "GET", httpBody: nil, callbackFunction: {data in
            
            //Decode the response to the login call. Add the '?' after the 'try' to avoid the following error:
            //Invalid conversion from throwing function of type '(_) throws -> ()' to non-throwing function type '(Data?) -> Void'
            if let stationsArray = try? JSONDecoder().decode([Station].self, from: data!) {
                
                //The array should not be empty
                XCTAssertTrue(stationsArray.count > 0)
                
                // Fullfil the expectation to let the test runner
                // know that it's OK to proceed
                expectation.fulfill()
            }
            else{
                
                XCTFail()
            }
        }
        )
        
        // Wait for the expectation to be fullfilled, or time out
        // after 2 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 2, handler: nil)
    }
}
