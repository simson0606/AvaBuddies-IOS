//
//  UserTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 31/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class UserTest: XCTestCase {
    
    var user: User?

    let serverConnection = MockServerConnection()
    let userRepository = UserRepository()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userRepository.serverConnection = serverConnection
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReceiveUser() {
        userRepository.getUser()
        
        XCTAssertTrue(serverConnection.route == "/user/profile")
    }
  

}
