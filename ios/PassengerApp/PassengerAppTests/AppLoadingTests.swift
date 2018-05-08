//
//  AppLoadingTests.swift
//  PassengerAppTests
//
//  Created by Salvador Orozco Villalever on 5/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
@testable import PassengerApp

class AppLoadingTests: XCTestCase {
    
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
    
    func testAppLoadingTime() {
        
        let APP_LAUNCH_TIME_KEY = "APP_LAUNCH_TIME_KEY"
        let appLaunchTime = UserDefaults.standard.object(forKey: APP_LAUNCH_TIME_KEY) as! Double
        let maxLaunchTime = 2.0
        XCTAssertTrue(appLaunchTime <= maxLaunchTime)
    }
}
