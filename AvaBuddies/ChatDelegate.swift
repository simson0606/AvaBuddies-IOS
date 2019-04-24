//
//  ChatDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol ChatDelegate {
    
    func chatsReceived(chats: [Chat])
    
    func failed()
}
