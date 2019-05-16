//
//  ChatsTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 16/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class ChatsTest: XCTestCase, ChatDelegate, ChatListDelegate {
    
    let serverConnection = MockServerConnection()
    let chatRepository = ChatRepository()
    
    var loginIsRequested = false
    var chatsAreReceived = false
    var isFailed = false
    
    override func setUp() {
        chatRepository.serverConnection = serverConnection
        chatRepository.chatDelegate = self
        chatRepository.chatListDelegate = self
    }

    override func tearDown() {
        loginIsRequested = false
        chatsAreReceived = false
        isFailed = false
    }

    func testReceiveChatList() {
        
        serverConnection.setMockResponse(response:
            "{\"chats\":[{\"_id\":\"5cdd689e395c7f252ec4ac30\",\"user1\":{\"name\":\"Simon Heij\",\"sharelocation\":false,\"image\":\"\",\"_id\":\"5cdbec70f99b9c37ad7fbd76\",\"email\":\"simon@projectsoa.onmicrosoft.com\",\"__v\":0},\"user2\":{\"name\":\"Michiel Cox\",\"sharelocation\":false,\"image\":\"\",\"_id\":\"5cdc61aefcaba10a7207006f\",\"email\":\"michielcox@projectsoa.onmicrosoft.com\",\"__v\":0},\"__v\":0}]}", success: true)
        
        chatRepository.getChatList()
        
        XCTAssertTrue(serverConnection.route == "/chat")
        XCTAssertTrue(serverConnection.method == "get")

        XCTAssertTrue(chatRepository.chats?.first?._id == "5cdd689e395c7f252ec4ac30")
        XCTAssertTrue(chatsAreReceived)
        XCTAssertFalse(isFailed)
    }

    func testMalformedReceiveChatList() {
        
        serverConnection.setMockResponse(response:
            "{\"chaticrosoft.com\",\"__v\":0},\"__v\":0}]}", success: true)
        
        chatRepository.getChatList()
        
        XCTAssertTrue(serverConnection.route == "/chats")
        XCTAssertTrue(serverConnection.method == "get")
        
        XCTAssertTrue(isFailed)
        XCTAssertFalse(chatsAreReceived)
    }
    
    func loginRequested() {
        loginIsRequested = true
    }
    
    func chatsReceived(chats: [Chat]) {
        chatsAreReceived = true
    }
    
    func failed() {
        isFailed = true
    }
}
