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
        serverConnection?.request(parameters: nil, to: Constants.ServerConnection.UserProfileRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            let userResponse = try! decoder.decode(UserResponse.self, from: result)
            self.user = userResponse.user
            self.userDelegate?.userReceived(user: self.user!)
        }, fail: nil)
    }
    
    func updateProfileImage(){
        let parameters = [
            "image": user?.image ?? "",
        ]

        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.UpdateProfileImageRoute, with: .post, completion: {
            (result) -> () in
            print("Image Change: \(result)")
        }, fail: nil)
        
    }
    
    func updateProfile(){
        let parameters = [
            "aboutme": user?.aboutme ?? "",
            "sharelocation": user?.sharelocation ?? false
            ] as [String : Any]

        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.UpdateProfileRoute, with: .post, completion: {
            (result) -> () in
            print("Profile Change: \(result)")
        }, fail: nil)
    }
    
    func deleteProfile() {
        serverConnection?.request(parameters: nil, to: Constants.ServerConnection.DeleteProfileRoute + (user?._id ?? ""), with: .delete, completion: {
            (result) -> () in
            self.userDelegate?.userDeleted()
        }, fail: nil)
    }
}
