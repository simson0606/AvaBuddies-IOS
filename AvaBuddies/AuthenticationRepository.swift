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
    
    
    func register(with email: String, with name: String, location sharelocation: Bool){
        let parameters = [
            "email": email,
            "password": Constants.ServerConnection.Secret,
            "name": name,
            "sharelocation": sharelocation
            ] as [String : Any]
        
        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.RegisterRoute, with: .post, completion: {
            (result) -> () in
                self.registerDelegate?.register()
        }, fail: {
            (result) -> () in
            print("Tester: \(String(data: result, encoding: .utf8) ?? "no result")")
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
                self.loginDelegate?.loginFailed(message: FailedLoginResponse(message: ""))
            }
            
        }, fail: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let message = try decoder.decode(FailedLoginResponse.self, from: result)
                self.loginDelegate?.loginFailed(message: message)

            } catch {
                self.loginDelegate?.loginFailed(message: FailedLoginResponse(message: ""))
            }
        })
    }
}
