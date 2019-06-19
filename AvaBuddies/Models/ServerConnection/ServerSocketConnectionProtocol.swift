//
//  ServerSocketConnectionProtocol.swift
//  AvaBuddies
//
//  Created by simon heij on 08/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol ServerSocketConnectionProtocol {
    func connect()
    func setUserOnline(id: String)
    func send(to event: String, with message: String)
    func listen(to event: String)
    
    func setConnectionDelegate(delegate: ServerSocketConnectionDelegate)
    func setMessageDelegate(delegate: ServerSocketMessageDelegate)
    
}
