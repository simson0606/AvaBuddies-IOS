//
//  ServerSocketConnectionDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 15/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol ServerSocketMessageDelegate {
    func receivedMessage(message: String)
}

protocol ServerSocketConnectionDelegate {
    func connectionEstablished()
}
