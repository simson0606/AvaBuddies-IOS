//
//  MSALClientDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 19/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol MSALClientDelegate {
    func receivedUserInfo(userinfo : GraphUser)
}
