//
//  UserTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 31/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class UserTest: XCTestCase, UserDelegate {
    
    var user: User?

    let serverConnection = MockServerConnection()
    let userRepository = UserRepository()
    
    var userIsReceived = false
    var userIsDeleted = false
    var isFailed = false
    override func setUp() {
        userRepository.serverConnection = serverConnection
        userRepository.userDelegate = self
    }

    override func tearDown() {
        userIsReceived = false
        userIsDeleted = false
        isFailed = false
    }

    func testReceiveUser() {
        
        serverConnection.setMockResponse(response:
            "{\"user\": {\"name\": \"User Test\",\"sharelocation\": true,\"isAdmin\": false,\"image\": \"\",\"_id\": \"5ca72bdad120192a4a4de201\",\"email\": \"UserTest@email.com\",\"password\": \"UserTest\"}}", success: true)
        
        userRepository.getUser()
        
        XCTAssertTrue(serverConnection.route == "/user/profile")
        XCTAssertTrue(userRepository.user?.name == "User Test")
        
        XCTAssertTrue(userIsReceived)
        XCTAssertFalse(isFailed)
    }
  
    func testMalformedReceiveUser() {
        
        serverConnection.setMockResponse(response:
            "{\"user\": {\"name\": \"User Test\",\"sharelocation\": tru}", success: true)
        
        userRepository.getUser()
        
        XCTAssertTrue(serverConnection.route == "/user/profile")
        
        XCTAssertFalse(userIsReceived)
        XCTAssertTrue(isFailed)
    }
    
    func testDeleteUser() {
        
        userRepository.user = User(_id: "id-testDeleteUser", name: "testDeleteUser", email: "testDeleteUser", aboutme: "testDeleteUser", image: "", sharelocation: true)
        
        userRepository.deleteProfile()
        
        XCTAssertTrue(serverConnection.route == "/user/destroy/id-testDeleteUser")
        
        XCTAssertFalse(userIsDeleted)
        XCTAssertTrue(isFailed)
    }

    func userReceived(user: User) {
        userIsReceived = true
    }
    
    func userDeleted() {
        userIsDeleted = true
    }
    
    func failed() {
        isFailed = true
    }
}
