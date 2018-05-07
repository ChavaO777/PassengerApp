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
}
