//
//  ChatMessage.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import CoreData

struct ChatMessage : Codable{
    var _id: String
    var chat: Chat
    var sender: User
    var message: String
    
    func toChatMessageModel(context: NSManagedObjectContext) -> ChatMessageModel {
        let model = ChatMessageModel(context: context)
        model.chat = chat._id
        model.id = _id
        model.message = message
        model.sender = sender._id
        model.dateTime = Date()
        return model
    }
}
