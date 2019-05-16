//
//  SearchTest.swift
//  AvaBuddiesTests
//
//  Created by Bryan van Lierop on 25/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import XCTest
@testable import AvaBuddies

class SearchTest: XCTestCase {
    
    var users : [User] = []
    
    override func setUp() {
        users = [
            User(_id: "id1",
                 name: "Test User",
                 email: "testuser@avabuddies.nl",
                 aboutme: "",
                 image: "",
                 sharelocation: true,
                 isPrivate: true,
                 tags: [
                    Tag(_id: "tag1", name: "Boot"),
                    Tag(_id: "tag2", name: "Kat")
                ]),
            User(_id: "id2",
                name: "Erik Appels",
                email: "erikappels@avabuddies.nl",
                aboutme: "",
                image: "",
                sharelocation: true,
                isPrivate: false,
                tags: [
                    Tag(_id: "tag1", name: "Boot"),
                    Tag(_id: "tag2", name: "Kat")
                ])
            ]
    }
    
    func testSearchFilter() {
        //TODO
    }
}
