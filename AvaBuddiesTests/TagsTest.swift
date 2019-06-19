//
//  TagsTest.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 18/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class TagsTest: XCTestCase, TagDelegate {
    
    
    let serverConnection = MockServerConnection()
    let tagRepository = TagRepository()
    
    var tagListIsReceived = false
    var isFailed = false
    
    override func setUp() {
        tagRepository.serverConnection = serverConnection
        tagRepository.tagDelegate = self
    }
    
    override func tearDown() {
        tagListIsReceived = false
        isFailed = false
    }

    func testReceiveTagList() {
        
        serverConnection.setMockResponse(response:
            "{\"tags\": [ {\"name\": \"Tag Test\",\"_id\": \"5ca72bdad120192a4a4de201\"} ] }", success: true)
        
        tagRepository.getTagList()
        
        XCTAssertTrue(serverConnection.route == "/tags")
        XCTAssertTrue(serverConnection.method == "get")
        XCTAssertTrue(tagRepository.tags?.first?.name == "Tag Test")
        XCTAssertTrue(tagListIsReceived)
        XCTAssertFalse(isFailed)
    }
    
    func testMalformedReceiveTagList() {
        
        serverConnection.setMockResponse(response:
            "{\"tags\": [ {\"nam\"\"_id\": \"5ca72bdad120192a4a4de201\"} ] }", success: true)
        
        tagRepository.getTagList()
        
        XCTAssertTrue(serverConnection.route == "/tags")
        XCTAssertTrue(serverConnection.method == "get")
        XCTAssertTrue(isFailed)
        XCTAssertFalse(tagListIsReceived)
    }
    
    func testFailedReceiveTagList() {
        
        serverConnection.setMockResponse(response:
            "{\"tags\": [ {\"name\": \"Tag Test\",\"_id\": \"5ca72bdad120192a4a4de201\"} ] }", success: false)
        
        tagRepository.getTagList()
        
        XCTAssertTrue(serverConnection.route == "/tags")
        XCTAssertTrue(serverConnection.method == "get")
        XCTAssertTrue(isFailed)
        XCTAssertFalse(tagListIsReceived)
    }
    
    func tagListReceived(tags: [Tag]) {
        tagListIsReceived = true
    }
    
    func failed() {
        isFailed = true
    }
    
}
