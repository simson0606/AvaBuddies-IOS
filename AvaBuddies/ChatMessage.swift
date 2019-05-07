//
//  ChatMessage.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import CoreData
import MessageKit

struct ChatMessage : Codable{
    var _id: String
    var chat: Chat
    var senderId: String
    var message: String
    var dateTime: Date?
    
    func toChatMessageModel(context: NSManagedObjectContext) -> ChatMessageModel {
        let model = ChatMessageModel(context: context)
        model.chat = chat._id
        model.id = _id
        model.message = message
        model.sender = senderId
        model.dateTime = Date()
        return model
    }
    
    init(model: ChatMessageModel, chat: Chat) {
        _id = model.id!
        self.chat = chat
        message = model.message!
        senderId = model.sender!
        dateTime = model.dateTime!
    }
    
    init(_id: String, chat: Chat, senderId: String, message: String) {
        self._id = _id
        self.chat = chat
        self.senderId = senderId
        self.message = message
        dateTime = Date()
    }
}

extension ChatMessage: MessageType {
    var messageId: String {
        return _id
    }
    
    var sender: Sender {
        return Sender(id: senderId, displayName: senderId)
    }
    
    var sentDate: Date {
        return dateTime ?? Date()
    }
    
    var kind: MessageKind {
        return .text(message)
    }
    
}

