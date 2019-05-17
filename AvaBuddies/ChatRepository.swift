//
//  ChatRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ChatRepository: ServerSocketConnectionDelegate {
    
    var serverConnection: ServerConnectionProtocol!
    var serverSocketConnection: ServerSocketConnectionProtocol!

    var chatDelegate: ChatDelegate?
    var chatListDelegate: ChatListDelegate?

    var chats: [Chat]?
    var listeningChats = [Chat]()
    
    func intitializeDelegate() {
        serverSocketConnection.setConnectionDelegate(delegate: self)
    }
    
    func userIsInChat(user: User) -> Bool{
        return chats?.filter{ chat in
            chat.user1 == user || chat.user2 == user
            }.count ?? 0 > 0
    }
    
    func setUserOnline(user: User) {
        serverSocketConnection.setUserOnline(id: user._id)
    }
    
    func connectionEstablished() {
        listeningChats = [Chat]()
        chatDelegate?.loginRequested()
    }
    
    func getChatList() {        
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.ChatRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ChatListResponse.self, from: result)
                self.chats = response.chats
                self.chatListDelegate?.chatsReceived(chats: self.chats!)
                self.chats?.forEach(){chat in
                    if !self.listeningChats.contains(chat) {
                        self.serverSocketConnection?.listen(to: chat._id)
                        self.listeningChats.append(chat)
                    }
                }
            } catch {
                self.chatListDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.chatListDelegate?.failed()
        })
    }
    
    func addChat(with user: User) {
        let parameters = ["id": user._id]

        serverConnection.request(parameters: parameters, to: "\(Constants.ServerConnection.ChatRoute)/\(user._id)", with: .post, completion: {
            (result) -> () in
                self.getChatList()
        }, fail: {
            (result) -> () in
            self.chatListDelegate?.failed()
        })
    }
    
    func removeChat(chat: Chat){
        serverConnection.request(parameters: nil, to: "\(Constants.ServerConnection.ChatRoute)/\(chat._id)", with: .delete, completion: {
            (result) -> () in
                self.getChatList()
        }, fail: {
            (result) -> () in
            self.chatListDelegate?.failed()
        })
    }
    
}
