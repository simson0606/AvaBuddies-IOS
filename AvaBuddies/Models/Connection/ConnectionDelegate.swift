//
//  FriendsDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
protocol ConnectionDelegate {
    func connectionsReceived(connections: [Connection])
    func requestUpdated()
    func failed()
}
