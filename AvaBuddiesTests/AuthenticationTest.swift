//
//  AuthenticationTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class AuthenticationTest: XCTestCase {

    let serverConnection = MockServerConnection()
    let authenticationRepository = AuthenticationRepository()
    
    override func setUp() {
        authenticationRepository.serverConnection = serverConnection
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAuthenticationString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        authenticationRepository.authenticate(with: "AuthenticationTest")
        
        XCTAssertTrue(serverConnection.message == "Authenticate AuthenticationTest")
    }
}
