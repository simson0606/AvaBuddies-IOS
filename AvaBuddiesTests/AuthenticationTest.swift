//
//  AuthenticationTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class AuthenticationTest: XCTestCase, LoginDelegate, RegisterDelegate {

    
    
    func register() {
        registerIsCompleted = true
    }
    
    func registerFailed() {
        registerIsFailed = true
    }
    

    var loginIsCompleted = false
    var loginIsFailed = false
    
    var registerIsCompleted = false
    var registerIsFailed = false
    
    let serverConnection = MockServerConnection()
    let authenticationRepository = AuthenticationRepository()
    
    override func setUp() {
        authenticationRepository.serverConnection = serverConnection
        authenticationRepository.loginDelegate = self
        authenticationRepository.registerDelegate = self
    }

    override func tearDown() {
         loginIsCompleted = false
         loginIsFailed = false
         registerIsFailed = false
         registerIsCompleted = false
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
    
    func testRegister() {
        serverConnection.setMockResponse(response: "{\"token\":\"MockServerConnection\"}", success: true)
        let email = "AuthenticationTest@email.com"
        let name = "test"
        let location = false
        authenticationRepository.register(with: email, with: name, location: location)
        
        XCTAssertTrue(serverConnection.route == "/auth/signup")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)
        XCTAssertTrue(serverConnection.parameters!["name"] as! String == name)
        XCTAssertTrue(serverConnection.parameters!["sharelocation"] as! Bool == location)
        
        XCTAssertTrue(registerIsCompleted)
        XCTAssertFalse(registerIsFailed)
    }
    
    func testFailedRegister() {
        serverConnection.setMockResponse(response: "Failed", success: false)
        let email = "AuthenticationTest@email.com"
        let name = "test"
        let location = false
        authenticationRepository.register(with: email, with: name, location: location)
        
        XCTAssertTrue(serverConnection.route == "/auth/signup")
        XCTAssertTrue(serverConnection.parameters!["email"] as! String == email)
        
        XCTAssertTrue(registerIsFailed)
        XCTAssertFalse(registerIsCompleted)
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
   
    func loginFailed(message: FailedLoginResponse) {
        loginIsFailed = true
    }
}
