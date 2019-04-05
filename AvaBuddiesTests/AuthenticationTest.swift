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

    var loginIsCompleted = false
    var loginIsFailed = false
    
    let serverConnection = MockServerConnection()
    let authenticationRepository = AuthenticationRepository()
    
    override func setUp() {
        authenticationRepository.serverConnection = serverConnection
        authenticationRepository.loginDelegate = self
    }

    override func tearDown() {
         loginIsCompleted = false
         loginIsFailed = false
    }

    func testLogin() {
        serverConnection.setMockResponse(response: "{\"token\":\"MockServerConnection\"}", success: true)
        let email = "AuthenticationTest@email.com"
        authenticationRepository.login(with: email)
        
        XCTAssertTrue(serverConnection.route == "/auth/login")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)

        XCTAssertTrue(loginIsCompleted)
        XCTAssertFalse(loginIsFailed)
    }
    
    func testMalformedResponseLogin() {
        serverConnection.setMockResponse(response: "{\"token\";\"}", success: true)
        let email = "AuthenticationTest@email.com"
        authenticationRepository.login(with: email)
        
        XCTAssertTrue(serverConnection.route == "/auth/login")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)
        
        XCTAssertTrue(loginIsFailed)
        XCTAssertFalse(loginIsCompleted)
    }
    
    func testFailedLogin() {
        serverConnection.setMockResponse(response: "Failed", success: false)
        let email = "AuthenticationTest@email.com"
        authenticationRepository.login(with: email)
        
        XCTAssertTrue(serverConnection.route == "/auth/login")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)
        
        XCTAssertTrue(loginIsFailed)
        XCTAssertFalse(loginIsCompleted)
    }
    
    func loggedIn() {
        loginIsCompleted = true
    }
   
    func loginFailed() {
        loginIsFailed = true
    }
}
