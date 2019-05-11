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
    var isPrivate: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.isPrivate = try container.decodeIfPresent(Bool.self, forKey: .isPrivate) ?? false
    }
}
