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

extension SwinjectStoryboard {
    
     @objc class func setup() {
        let msalClient = MSALClient()
        let accessTokenAdapter = AccessTokenAdapter()
        let serverConnection = ServerConnection(accessTokenAdapter: accessTokenAdapter)
        let authenticationRepository = AuthenticationRepository()
        let userRepository = UserRepository()
        let connectionRepository = ConnectionRepository()
        
        authenticationRepository.serverConnection = serverConnection
        authenticationRepository.accessTokenAdapter = accessTokenAdapter
        userRepository.serverConnection = serverConnection
        connectionRepository.serverConnection = serverConnection
        
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
        
        defaultContainer.register(MSALClient.self) { _ in msalClient }
        defaultContainer.register(AuthenticationRepository.self) {_ in authenticationRepository}
        defaultContainer.register(UserRepository.self) {_ in userRepository}
        defaultContainer.register(ConnectionRepository.self) {_ in connectionRepository}
    }
}
