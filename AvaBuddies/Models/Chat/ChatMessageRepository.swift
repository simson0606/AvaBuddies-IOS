//
//  ChatMessageReposiitory.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import CoreData

class ChatMessageRepository: ServerSocketMessageDelegate {
    
    var persistentContainer: NSPersistentContainer!
    var userRepository: UserRepository!
    var serverSocketConnection: ServerSocketConnectionProtocol!
    var chatMessageDelegate: ChatMessageDelegate?

    func intitializeDelegate() {
        serverSocketConnection.setMessageDelegate(delegate: self)
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getMessages(for chat: Chat, section: Int) -> [ChatMessage] { 
        let fetchRequest: NSFetchRequest<ChatMessageModel> = ChatMessageModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat._id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
        fetchRequest.fetchOffset = Constants.LocalStoragePageSize * section
        fetchRequest.fetchLimit = Constants.LocalStoragePageSize
        do {
            var results = try viewContext.fetch(fetchRequest)
            results.reverse()
            return results.map{ result in
                return ChatMessage(model: result, chat: chat)
            }
        } catch {
            chatMessageDelegate?.failed()
            return [ChatMessage]()
        }
        
    }
    
    func sendMessage(chat: Chat, message: ChatMessage) {
        do {
            _ = message.toChatMessageModel(context: viewContext)
            try viewContext.save()
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
            let messageJson = try encoder.encode(message)
            serverSocketConnection.send(to: chat._id, with: String(data: messageJson, encoding: .utf8)!)
        } catch {
            chatMessageDelegate?.failed()
        }
    }
    
    func clear(for chat: Chat){
        let fetchRequest: NSFetchRequest = ChatMessageModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat._id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try viewContext.execute(deleteRequest)
        } catch {
            chatMessageDelegate?.failed()
        }
    }
    
    func purge(except chats: [Chat]) {
        let ids = chats.map(){chat in
            chat._id
        }
        let fetchRequest: NSFetchRequest = ChatMessageModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "NOT (chat IN %@)", ids)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            let results = try viewContext.fetch(fetchRequest)
            if results.count > 0 {
                print("Purging \(results.count) messages which do not belong to a chat")
                try viewContext.execute(deleteRequest)
            }
        } catch {
            chatMessageDelegate?.failed()
        }
    }
    
    func receivedMessage(message: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        do {
            let decoded = try decoder.decode(ChatMessage.self, from: message.data(using: .utf8)!)
            _ = decoded.toChatMessageModel(context: viewContext)
            try viewContext.save()
            chatMessageDelegate?.messageReceived(message: decoded)
            serverSocketConnection.send(to: Constants.ServerConnection.ChatAck, with: decoded.id)
        } catch {
            chatMessageDelegate?.failed()
        }
    }
    
}
