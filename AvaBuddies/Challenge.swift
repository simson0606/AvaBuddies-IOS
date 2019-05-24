//
//  Challenge.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 24/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct ChallengeListResponse : Codable {
    var challenges: [Challenge]
}

struct Challenge: Codable {
    var _id: String
    var title: String
    var description: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
    
    init(_id: String, title: String, description: String) {
        self._id = _id
        self.title = title
        self.description = description
    }
}
