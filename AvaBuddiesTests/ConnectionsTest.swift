//
//  AvaBuddiesTests.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 18/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class ConnectionsTest: XCTestCase, ConnectionDelegate {

    let serverConnection = MockServerConnection()
    var connectionRepository = ConnectionRepository()
    
    var connectionsIsReceived = false
    var requestIsUpdated = false
    var isFailed = false
    
    override func setUp() {
        connectionRepository.serverConnection = serverConnection
        connectionRepository.connectionDelegate = self
    }

    override func tearDown() {
        connectionsIsReceived = false
        requestIsUpdated = false
        isFailed = false
    }

    func testConnectionsReceived() {
        
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        let friend = User(_id: "id-testUser2", name: "testUser2", email: "testUser2", aboutme: "testUser2", image: "", sharelocation: true)
        serverConnection.setMockResponse(response: "{\"connections\":[{\"confirmed\":false,\"validated\":false,\"_id\":\"5cab3876675cf6363382115a\",\"friend1\":\"\(user._id)\",\"friend2\":\"\(friend._id)\"},{\"confirmed\":false,\"validated\":false,\"_id\":\"5cab3888675cf6363382115b\",\"friend1\":\"5ca72bdad120192a4a4de201\",\"friend2\":\"5ca72bdad120192a4a4de201\"}]}", success: true)
        
        connectionRepository.getConnectionList()
        
        XCTAssertTrue(serverConnection.route == "/friend/allconnections")
        
        let exists = connectionRepository.connectionExists(with: user , and: friend)
        
        XCTAssertTrue(exists)
        
        XCTAssertTrue(connectionsIsReceived)
        XCTAssertFalse(isFailed)
    }

    func testMalformedConnectionsReceived() {
        serverConnection.setMockResponse(response: "{\"connections\":[{\"confirmed\":false\":0}]}", success: true)
        
        connectionRepository.getConnectionList()
        
        XCTAssertTrue(serverConnection.route == "/friend/allconnections")
        
        XCTAssertTrue(isFailed)
        XCTAssertFalse(connectionsIsReceived)
    }

    func testConnectionsReceivedFailed() {
        serverConnection.setMockResponse(response: "{}", success: false)
        
        connectionRepository.getConnectionList()
        
        XCTAssertTrue(serverConnection.route == "/friend/allconnections")
        
        XCTAssertTrue(isFailed)
        XCTAssertFalse(connectionsIsReceived)
    }
    
    func testRequestConnection() {
        serverConnection.setMockResponse(response: "{}", success: true)
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        connectionRepository.requestConnection(with: user)
        
        XCTAssertTrue(serverConnection.route == "/friend/request")
        XCTAssertTrue(serverConnection.parameters!["friend"] as! String == user._id)

        XCTAssertTrue(requestIsUpdated)
        XCTAssertFalse(isFailed)
    }
    
    func testCancelConnection() {
        serverConnection.setMockResponse(response: "{}", success: true)
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        connectionRepository.cancelConnection(with: user)
        
        XCTAssertTrue(serverConnection.route == "/friend/cancelrequest")
        XCTAssertTrue(serverConnection.parameters!["friend"] as! String == user._id)
        
        XCTAssertTrue(requestIsUpdated)
        XCTAssertFalse(isFailed)
    }

    func testValidateConnection() {
        serverConnection.setMockResponse(response: "{}", success: true)
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        connectionRepository.validateConnection(with: user._id)
        
        XCTAssertTrue(serverConnection.route == "/friend/validaterequest")
        XCTAssertTrue(serverConnection.parameters!["friend"] as! String == user._id)
        
        XCTAssertTrue(requestIsUpdated)
        XCTAssertFalse(isFailed)
    }
    
    func testAcceptConnection() {
        serverConnection.setMockResponse(response: "{}", success: true)
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        connectionRepository.acceptConnection(with: user)
        
        XCTAssertTrue(serverConnection.route == "/friend/acceptrequest")
        XCTAssertTrue(serverConnection.parameters!["friend"] as! String == user._id)
        
        XCTAssertTrue(requestIsUpdated)
        XCTAssertFalse(isFailed)
    }
    
    func testDenyConnection() {
        serverConnection.setMockResponse(response: "{}", success: true)
        let user = User(_id: "id-testUser", name: "testUser", email: "testUser", aboutme: "testUser", image: "", sharelocation: true)
        connectionRepository.denyConnection(with: user)
        
        XCTAssertTrue(serverConnection.route == "/friend/denyrequest")
        XCTAssertTrue(serverConnection.parameters!["friend"] as! String == user._id)
        
        XCTAssertTrue(requestIsUpdated)
        XCTAssertFalse(isFailed)
    }
    
    func connectionsReceived(connections: [Connection]) {
        connectionsIsReceived = true
    }
    
    func requestUpdated() {
        requestIsUpdated = true
    }
    
    func failed() {
        isFailed = true
    }
    
}
