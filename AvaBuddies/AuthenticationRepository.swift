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
    var accessTokenAdapter: AccessTokenAdapter?
    
    
    func register(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        
        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.RegisterRoute, with: .post, completion: {
            (result) -> () in
            self.registerDelegate?.registered()
        }, fail: {
            (result) -> () in
            self.registerDelegate?.registerFailed()
        })
    }
    
    func login(with email: String){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret
        ]
        
        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.LoginRoute, with: .post, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let token = try decoder.decode(LoginResponse.self, from: result)
                self.accessTokenAdapter?.accessToken = token.token
                self.loginDelegate?.loggedIn()
            } catch {
                self.loginDelegate?.loginFailed()
            }
            
        }, fail: {
            (result) -> () in
            self.loginDelegate?.loginFailed()
        })
    }
}
