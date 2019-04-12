//
//  LoginResponse.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    var token: String
}

struct FailedLoginResponse : Codable {
    var message: String
}
