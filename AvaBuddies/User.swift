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
    
    
    func getUIImage() -> UIImage {
        if image != nil {
            let imageData = Data(base64Encoded: self.image!)!
            return UIImage(data: imageData) ?? UIImage()
        }
        return UIImage()
    }
    
    mutating func setImage(image: UIImage) {
        let imageData = image.pngData()!
        self.image = imageData.base64EncodedString()
    }
}


