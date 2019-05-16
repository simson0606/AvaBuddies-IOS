//
//  Chat.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct ChatListResponse : Codable {
    var chats : [Chat]
}


struct Chat : Codable, Equatable{
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs._id == rhs._id
    }
    
    var _id: String
    var user1: User
    var user2: User
    
    func getOtherUser(me: User) -> User{
        return user1 == me ? user2 : user1
    }
}


