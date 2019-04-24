//
//  ChatRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ChatRepository {
    
    var serverConnection: ServerConnectionProtocol!
    var userRepository: UserRepository!
    
    var chatDelegate: ChatDelegate?
    
    var chats: [Chat]?
    
    func userIsInChat(user: User) -> Bool{
        return chats?.filter{ chat in
            chat.user1 == user || chat.user2 == user
            }.count ?? 0 > 0
    }
    
    func getChatList() {
        if chats == nil {
            chats = [Chat]()
            chats?.append(Chat(_id: "1", user1: userRepository.user!, user2: userRepository.users![0]))
        }
        chatDelegate?.chatsReceived(chats: self.chats!)
    }
    
    func addChat(with: User, and: User) {
        chats?.append(Chat(_id: "\(with._id)-\(and._id)", user1: with, user2: and))
    }
    
    func removeChat(chat: Chat){
        if let index = chats?.firstIndex(of: chat) {
            chats?.remove(at: index)
        }
    }
    
}
