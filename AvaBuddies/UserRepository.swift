//
//  UserRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class UserRepository {
    
    var serverConnection: ServerConnectionProtocol!
    
    var userDelegate: UserDelegate?
    var userListDelegate: UserListDelegate?
    var user: User?
    var users: [User]?

    func getUser(refresh: Bool = false){
        if user != nil && !refresh {
            self.userDelegate?.userReceived(user: self.user!)
            return
        }
        
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.UserProfileRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let userResponse = try decoder.decode(UserResponse.self, from: result)
                self.user = userResponse.user
                self.userDelegate?.userReceived(user: self.user!)
            } catch {
                self.userDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.userDelegate?.failed()
        })
    }
    
    func updateProfileImage(){
        let parameters = [
            "image": user?.image ?? "",
        ]
        print("Image length: \(user?.image?.count ?? 0)")
        serverConnection.request(parameters: parameters, to: Constants.ServerConnection.UpdateProfileImageRoute, with: .post, completion: {
            (result) -> () in
            print("Image Change: \(result)")
        }, fail: {
            (result) -> () in
            print("Image Change Failed: \(result)")
            self.userDelegate?.failed()
        })
        
    }
    
    func updateProfile(){
        let parameters = [
            "aboutme": user?.aboutme ?? "",
            "sharelocation": user?.sharelocation ?? false,
            "tags": user?.tags?.map{tag in tag._id} ?? [String](),
            "isPrivate": user?.isPrivate ?? true
            ] as [String : Any]

        serverConnection.request(parameters: parameters, to: Constants.ServerConnection.UpdateProfileRoute, with: .post, completion: {
            (result) -> () in
            print("Profile Change: \(result)")
        }, fail: {
            (result) -> () in
            self.userDelegate?.failed()
        })
    }
    
    func deleteProfile() {
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.DeleteProfileRoute + (user?._id ?? ""), with: .delete, completion: {
            (result) -> () in
            self.userDelegate?.userDeleted()
        }, fail: {
            (result) -> () in
            self.userDelegate?.failed()
        })
    }
    
    func getUserList(refresh: Bool = false) {
        if users != nil && !refresh {
            self.userListDelegate?.userListReceived(users: self.users!)
            return
        }
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.UserListRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let usersResponse = try decoder.decode(UsersResponse.self, from: result)
                self.users = usersResponse.users
                self.userListDelegate?.userListReceived(users: self.users!)
            } catch {
                self.userListDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.userListDelegate?.failed()
        })
    }
    
    func getUserBy(id: String) -> User? {
        return users?.first(where: {$0._id == id})
    }
}
