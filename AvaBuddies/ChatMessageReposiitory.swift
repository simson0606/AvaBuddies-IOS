//
//  ChatMessageReposiitory.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ChatMessageRepository {
    
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
    
}
