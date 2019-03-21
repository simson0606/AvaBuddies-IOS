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
        
        
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
        }
        defaultContainer.storyboardInitCompleted(AccountViewController.self) { r, c in
            c.msalClient = r.resolve(MSALClient.self)
        }
        
        defaultContainer.register(MSALClient.self) { _ in msalClient }
    }
}
