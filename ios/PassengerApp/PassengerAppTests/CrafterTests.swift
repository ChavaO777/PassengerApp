//
//  CrafterTests.swift
//  PassengerAppTests
//
//  Created by Salvador Orozco Villalever on 5/7/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
@testable import PassengerApp

class CrafterTests: XCTestCase {
    
    let TOTAL_EXISTENT_CRAFTERS = 3
    
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
            "id": "4543GJDKSM94030",
            "name": "Crafter 1",
            "lat": 19.12717,
            "lng": -98.260555,
            "isActive": true,
            "total_seats": 12,
            "occupied_seats": 1,
            "createdAt": "2018-05-02T15:49:27.603Z",
            "updatedAt": "2018-05-02T15:49:27.603Z"
        }
        """.data(using: .utf8)! // our data in native (JSON) format
        
        do{
            
            let myCrafter = try JSONDecoder().decode(Crafter.self, from: data) // Decoding our data
            let markerSnippet = myCrafter.getMarkerSnippet(total_seats: myCrafter.getTotalSeats(), occupied_seats: myCrafter.getOccupiedSeats())
            XCTAssertEqual(markerSnippet, "Capacidad: 12 pasajeros\nAsientos disponibles: 11")
            
        }catch let jsonError{
            
            print(jsonError)
        }
    }
    
    func testGetCraftersFromServer() {
        
        let expectation = self.expectation(description: "Crafter retrieval from the server")
        
        //Call the backend with the required parameters to try to login and handle the response later
        HTTPHandler.makeHTTPRequest(route: Crafter.ROUTE, httpMethod: "GET", httpBody: nil, callbackFunction: {data in
            
                //Decode the response to the login call. Add the '?' after the 'try' to avoid the following error:
                //Invalid conversion from throwing function of type '(_) throws -> ()' to non-throwing function type '(Data?) -> Void'
                if let craftersArray = try? JSONDecoder().decode([Crafter].self, from: data!) {
                    
                    //The array should not be empty
                    XCTAssertTrue(craftersArray.count == self.TOTAL_EXISTENT_CRAFTERS)
                    
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
        // after 5 seconds. This is where the test runner will pause.
        waitForExpectations(timeout: 5, handler: nil)
    }
}
