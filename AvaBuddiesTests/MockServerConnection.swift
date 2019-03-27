//
//  MockServerConnection.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
@testable import AvaBuddies

class MockServerConnection: ServerConnectionProtocol {
    
    var message: String?
    var url: String?
    
    func send(message: String, to url: String) {
        self.message = message
        self.url = url
    }
    
    
    
    
}
