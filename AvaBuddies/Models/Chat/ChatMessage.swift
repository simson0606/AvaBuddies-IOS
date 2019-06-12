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
    var id: String
    var chatId: String
    var senderId: String
    var message: String
    var dateTime: Date?
    
    func toChatMessageModel(context: NSManagedObjectContext) -> ChatMessageModel {
        let model = ChatMessageModel(context: context)
        model.chat = chatId
        model.id = id
        model.message = message
        model.sender = senderId
        model.dateTime = Date()
        return model
    }
    
    init(model: ChatMessageModel, chat: Chat) {
        id = model.id!
        self.chatId = chat._id
        message = model.message!
        senderId = model.sender!
        dateTime = model.dateTime!
    }
    
    init(_id: String, chat: Chat, senderId: String, message: String) {
        self.id = _id
        self.chatId = chat._id
        self.senderId = senderId
        self.message = message
        dateTime = Date()
    }
}

extension ChatMessage: MessageType {
    var messageId: String {
        return id
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

