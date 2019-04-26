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
    
    func test(){
        
        
        let fetchRequest: NSFetchRequest<ChatMessageModel> = ChatMessageModel.fetchRequest()
        let results = try! viewContext.fetch(fetchRequest)
        
        print(results)
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
    
    func sendMessage(messageText: String) {
        
    }
    
}
