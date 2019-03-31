//
//  UserRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class UserRepository {
    
    var serverConnection: ServerConnectionProtocol?
    
    var userDelegate: UserDelegate?
    var user: User?
    

    func getUser(){
        serverConnection?.get(parameters: nil, to: Constants.ServerConnection.UserProfileRoute, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            let userResponse = try! decoder.decode(UserResponse.self, from: result)
            self.user = userResponse.user
            self.userDelegate?.userReceived(user: self.user!)
        })
    }
    
    func updateProfileImage(){
        let parameters = [
            "image": user?.image ?? "",
        ]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.UpdateProfileImageRoute, completion: {
            (result) -> () in
            print("Image Change: \(result)")
        })
    }
    
    func updateProfile(){
        let parameters = [
            "aboutme": user?.aboutme ?? "",
            "sharelocation": user?.sharelocation ?? false
            ] as [String : Any]
        serverConnection?.post(parameters: parameters, to: Constants.ServerConnection.UpdateProfileRoute, completion: {
            (result) -> () in
            print("Profile Change: \(result)")
        })
    }
}
