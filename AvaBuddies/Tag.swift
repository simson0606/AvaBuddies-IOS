//
//  Tag.swift
//  AvaBuddies
//
//  Created by simon heij on 16/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct TagListResponse : Codable {
    var tags: [Tag]
}

struct Tag : Codable, Equatable {
    var _id: String
    var name: String
}
