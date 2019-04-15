//
//  UserTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 31/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class UserTest: XCTestCase, UserDelegate, UserListDelegate {
    
    var user: User?

    let serverConnection = MockServerConnection()
    let userRepository = UserRepository()
    
    var userIsReceived = false
    var userListIsReceived = false
    var userIsDeleted = false
    var isFailed = false
    override func setUp() {
        userRepository.serverConnection = serverConnection
        userRepository.userDelegate = self
        userRepository.userListDelegate = self
    }

    override func tearDown() {
        userIsReceived = false
        userIsDeleted = false
        isFailed = false
        userListIsReceived = false
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
        serverConnection.setMockResponse(response: "{}", success: true)

        userRepository.user = User(_id: "id-testDeleteUser", name: "testDeleteUser", email: "testDeleteUser", aboutme: "testDeleteUser", image: "", sharelocation: true)
        
        userRepository.deleteProfile()
        
        XCTAssertTrue(serverConnection.route == "/user/destroy/id-testDeleteUser")
        
        XCTAssertTrue(userIsDeleted)
        XCTAssertFalse(isFailed)
    }
    
    func testReceiveUserList() {
        
        serverConnection.setMockResponse(response:
            "{\"users\": [ {\"name\": \"User Test\",\"sharelocation\": true,\"isAdmin\": false,\"image\": \"\",\"_id\": \"5ca72bdad120192a4a4de201\",\"email\": \"UserTest@email.com\",\"password\": \"UserTest\"} ] }", success: true)
        
        userRepository.getUserList()
        
        XCTAssertTrue(serverConnection.route == "/user/list")
        
        XCTAssertTrue(userListIsReceived)
        XCTAssertFalse(isFailed)
    }

    func testMalformedReceiveUserList() {
        
        serverConnection.setMockResponse(response:
            "{\"users\": [ {\"name\": \"User Test\",\"sharelocation}", success: true)
        
        userRepository.getUserList()
        
        XCTAssertTrue(serverConnection.route == "/user/list")
        
        XCTAssertTrue(isFailed)
        XCTAssertFalse(userListIsReceived)
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
    
    func userListReceived(users: [User]) {
        userListIsReceived = true
    }
}
