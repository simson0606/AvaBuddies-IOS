//
//  Uset.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import UIKit

struct UserResponse : Codable {
    var user: User
}

struct UsersResponse: Codable {
    var users: [User]
}


struct User: Codable {
    var _id: String
    var name: String
    var email: String
    var aboutme: String?
    var image: String?
    var sharelocation: Bool
    var isPrivate: Bool?
    var tags: [Tag]?
    
    func getUIImage() -> UIImage? {
        if image != nil && !image!.isEmpty {
            let imageData = Data(base64Encoded: self.image!, options: .ignoreUnknownCharacters)
            if imageData != nil {
                return UIImage(data: imageData!)
            }
        }
        return nil
    }
    
    mutating func setImage(image: UIImage) {
        let imageData = image.pngData()!
        self.image = imageData.base64EncodedString()
    }
}


