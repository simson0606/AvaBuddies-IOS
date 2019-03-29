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
        let serverConnection = ServerConnection()
        let authenticationRepository = AuthenticationRepository()
        
        authenticationRepository.serverConnection = serverConnection
        
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
            c.authenticationRepository = r.resolve(AuthenticationRepository.self)
        }
        defaultContainer.storyboardInitCompleted(AccountViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
        }
        
        defaultContainer.register(MSALClient.self) { _ in msalClient }
        defaultContainer.register(AuthenticationRepository.self) {_ in authenticationRepository}
    }
}
