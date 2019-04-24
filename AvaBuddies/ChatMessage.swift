//
//  ChatMessage.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct ChatMessage : Codable{
    var _id: String
    var chat: Chat
    var sender: User
    var message: String
}
