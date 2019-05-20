//
//  Connection.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct ConnectionsResponse: Codable {
    var friends: [Connection]
}

struct RequestsResponse: Codable {
    var own_requests: [Connection]
    var requests: [Connection]
}

struct Connection: Codable {
    var confirmed: Bool
    var validated: Bool
    var _id: String
    var user: String
    var friend: String
}
