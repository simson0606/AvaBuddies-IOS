//
//  AuthenticationRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 25/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
class AuthenticationRepository {
    
    var registerDelegate: RegisterDelegate?
    var loginDelegate: LoginDelegate?
    var serverConnection: ServerConnectionProtocol?
    private var token: LoginResponse?
    
    
    func register(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.RegisterRoute, completion: {
            (result) -> () in
            self.registerDelegate?.registered()
        })
    }
    
    func login(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.LoginRoute, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            self.token = try! decoder.decode(LoginResponse.self, from: result)
            self.loginDelegate?.loggedIn()
        })
    }
}
