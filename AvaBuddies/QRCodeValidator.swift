//
//  QRCodeValidator.swift
//  AvaBuddies
//
//  Created by simon heij on 09/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class QRCodeValidator {
    func validate(friendRequest: FriendRequest) -> Bool{
        
        let elapsed = Date().timeIntervalSince(friendRequest.dateTime)
        return Int(elapsed) < Constants.QrValidSeconds
    }
}
