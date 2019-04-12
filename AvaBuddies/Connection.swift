//
//  Connection.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct ConnectionsResponse: Codable {
    var connections: [Connection]
}

struct Connection: Codable {
    var confirmed: Bool
    var _id: String
    var friend1: String
    var friend2: String
}
