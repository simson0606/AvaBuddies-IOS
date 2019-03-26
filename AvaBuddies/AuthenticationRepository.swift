//
//  AuthenticationRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 25/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
class AuthenticationRepository {
    
    var serverConnection: ServerConnectionProtocol?
    
    func authenticate(with email: String){
        serverConnection?.send(message: "Authenticate \(email)", to: "avabuddies")
    }
}
