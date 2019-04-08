//
//  AuthenticationDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 29/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol RegisterDelegate {
    func registered()
    func registerFailed()
}

protocol LoginDelegate {
    func loggedIn()
    func loginFailed()
}
