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
    
    func register(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.RegisterRoute, completion: {
            (result) -> () in
            print(result)
        })
    }
    
    func login(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.LoginRoute, completion: {
            (result) -> () in
            print(result)
        })
    }
}
