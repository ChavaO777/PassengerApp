//
//  LoginTests.swift
//  PassengerAppTests
//
//  Created by Salvador Orozco Villalever on 5/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import XCTest
@testable import PassengerApp

class LoginTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginWithWrongCredentials() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let username = "passengerX"
        let password = "password"
    
        var parameters = [String: String]()
        parameters["id"] = username
        parameters["password"] = password
        
        let expectation = self.expectation(description: "Failed login")
        
         //Call the backend with the required parameters to try to login and handle the response later
         HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: {data in
         
            //Decode the response to the login call
            if let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] {
               
               XCTAssertTrue(loginResponseDictionary["message"] != nil)
               
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
   
   func testLoginWithEmptyCredentials() {
    // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let username = ""
        let password = ""
        
        var parameters = [String: String]()
        parameters["id"] = username
        parameters["password"] = password
      
        let expectation = self.expectation(description: "Failed login")
        
         //Call the backend with the required parameters to try to login and handle the response later
         HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: {data in
         
            //Decode the response to the login call
            if let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] {
               
               XCTAssertTrue(loginResponseDictionary["message"] != nil)
               
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
    
    func testLoginWithCorrectCredentials() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let username = "passenger1"
        let password = "secret"
        
        var parameters = [String: String]()
        parameters["id"] = username
        parameters["password"] = password
      
        let expectation = self.expectation(description: "Failed login")
        
        //Call the backend with the required parameters to try to login and handle the response later
      HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: {data in
         
            //Decode the response to the login call
            if let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] {
               
               XCTAssertTrue(loginResponseDictionary[UserConfiguration.TOKEN_KEY] != nil)
               
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
    
    func testLoginWithoutCredentials() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let parameters = [String: String]()
      
        let expectation = self.expectation(description: "Failed login")
        
        //Call the backend with the required parameters to try to login and handle the response later
        HTTPHandler.makeHTTPPostRequest(route: Passenger.ROUTE, parameters: parameters, callbackFunction: {data in
         
            //Decode the response to the login call
            if let loginResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] {
               
               XCTAssertTrue(loginResponseDictionary["message"] != nil)
               
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
