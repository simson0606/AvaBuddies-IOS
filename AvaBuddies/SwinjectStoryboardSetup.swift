//
//  SwinjectStoryboardSetup.swift
//  AvaBuddies
//
//  Created by simon heij on 21/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import CoreData

extension SwinjectStoryboard {
    
   class func setup() {
        let msalClient = MSALClient()
        let accessTokenAdapter = AccessTokenAdapter()
        let serverConnection = ServerConnection(accessTokenAdapter: accessTokenAdapter)
    
        let serverSocketConnection = ServerSocketConnection()
        serverSocketConnection.connect()
    
        let authenticationRepository = AuthenticationRepository()
        let userRepository = UserRepository()
        let connectionRepository = ConnectionRepository()
        let tagRepository = TagRepository()
        let chatRepository = ChatRepository()
        let chatMessageRepository = ChatMessageRepository()
    
        let chatMessagePersistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "ChatMessageModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()

        authenticationRepository.serverConnection = serverConnection
        authenticationRepository.accessTokenAdapter = accessTokenAdapter
        userRepository.serverConnection = serverConnection
        connectionRepository.serverConnection = serverConnection
        tagRepository.serverConnection = serverConnection
        chatRepository.serverConnection = serverConnection
        chatRepository.serverSocketConnection = serverSocketConnection
        chatRepository.intitializeDelegate()
        chatMessageRepository.persistentContainer = chatMessagePersistentContainer
        chatMessageRepository.serverSocketConnection = serverSocketConnection
        chatMessageRepository.intitializeDelegate()
    
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
            c.authenticationRepository = r.resolve(AuthenticationRepository.self)
        }
        defaultContainer.storyboardInitCompleted(ProfileViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
            c.userRepository = r.resolve(UserRepository.self)
        }
        defaultContainer.storyboardInitCompleted(SearchPeopleViewController.self) { r, c in
            c.userRepository = r.resolve(UserRepository.self)
            c.connectionRepository = r.resolve(ConnectionRepository.self)
        }
        defaultContainer.storyboardInitCompleted(PublicProfileViewController.self) { r, c in
            c.connectionRepository = r.resolve(ConnectionRepository.self)
            c.userRepository = r.resolve(UserRepository.self)
        }
        defaultContainer.storyboardInitCompleted(NearbyViewController.self) { r, c in
            c.connectionRepository = r.resolve(ConnectionRepository.self)
            c.userRepository = r.resolve(UserRepository.self)
        }
        defaultContainer.storyboardInitCompleted(QRFriendRequestViewController.self) { r, c in
            c.connectionRepository = r.resolve(ConnectionRepository.self)
            c.userRepository = r.resolve(UserRepository.self)
        }
        defaultContainer.storyboardInitCompleted(QRScannerViewController.self) { r, c in
            c.connectionRepository = r.resolve(ConnectionRepository.self)
        }
        defaultContainer.storyboardInitCompleted(RegisterViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
            c.authenticationRepository = r.resolve(AuthenticationRepository.self)
        }
        defaultContainer.storyboardInitCompleted(SelectTagsViewController.self) { r, c in
            c.userRepository = r.resolve(UserRepository.self)
            c.tagRepository = r.resolve(TagRepository.self)
        }
        defaultContainer.storyboardInitCompleted(ChatListViewController.self) { r, c in
            c.userRepository = r.resolve(UserRepository.self)
            c.chatRepository = r.resolve(ChatRepository.self)
            c.chatMessageRepository = r.resolve(ChatMessageRepository.self)
        }
        defaultContainer.storyboardInitCompleted(AddChatViewController.self) { r, c in
            c.userRepository = r.resolve(UserRepository.self)
            c.chatRepository = r.resolve(ChatRepository.self)
        }
        defaultContainer.storyboardInitCompleted(ChatViewController.self) { r, c in
            c.userRepository = r.resolve(UserRepository.self)
            c.chatMessageRepository = r.resolve(ChatMessageRepository.self)
        }
    
        defaultContainer.register(MSALClient.self) { _ in msalClient }
        defaultContainer.register(AuthenticationRepository.self) {_ in authenticationRepository}
        defaultContainer.register(UserRepository.self) {_ in userRepository}
        defaultContainer.register(ConnectionRepository.self) {_ in connectionRepository}
        defaultContainer.register(TagRepository.self) {_ in tagRepository}
        defaultContainer.register(ChatRepository.self) {_ in chatRepository}
        defaultContainer.register(ChatMessageRepository.self) {_ in chatMessageRepository}

    }
}
