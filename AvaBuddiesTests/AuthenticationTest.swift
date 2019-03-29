//
//  AuthenticationTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class AuthenticationTest: XCTestCase, LoginDelegate {

    var loginCompleted = false

    let serverConnection = MockServerConnection()
    let authenticationRepository = AuthenticationRepository()
    
    override func setUp() {
        authenticationRepository.serverConnection = serverConnection
        authenticationRepository.loginDelegate = self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let email = "AuthenticationTest@email.com"
        authenticationRepository.login(with: email)
        
        XCTAssertTrue(serverConnection.route == "/auth/login")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)

        XCTAssertTrue(loginCompleted)
    }
    
    func loggedIn() {
        loginCompleted = true
    }
   
}
