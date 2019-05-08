//
//  ChatMessageReposiitory.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import CoreData

class ChatMessageRepository {
    
    var persistentContainer: NSPersistentContainer!
    var userRepository: UserRepository!

    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func getMessages(for chat: Chat, section: Int) -> [ChatMessage] { 
        let fetchRequest: NSFetchRequest<ChatMessageModel> = ChatMessageModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat._id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
        fetchRequest.fetchOffset = Constants.LocalStoragePageSize * section
        fetchRequest.fetchLimit = Constants.LocalStoragePageSize
        var results = try! viewContext.fetch(fetchRequest)
        results.reverse()
        return results.map{ result in
            return ChatMessage(model: result, chat: chat)
        }
    }

    
    var chatMessageDelegate: ChatMessageDelegate?
    
    private var chats = [Chat]()
    
    func startListening(to chats: [Chat]){
        self.chats.append(contentsOf: chats)
    }
    
    func startListening(to chat: Chat){
        self.chats.append(chat)
    }
    
    func stopListening(){
        
    }
    
    func messageReceived(message: ChatMessage) {
        _ = message.toChatMessageModel(context: viewContext)
        try! viewContext.save()
    }
    
    func sendMessage(message: ChatMessage) {
        _ = message.toChatMessageModel(context: viewContext)
        try! viewContext.save()
    }
    
    func clear(for chat: Chat){
        let fetchRequest: NSFetchRequest = ChatMessageModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chat == %@", chat._id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try! viewContext.execute(deleteRequest)

    }
    
}
