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
    
    var parameters: [String: Any]?
    var route: String?
    
    func post(parameters: [String: Any], to route: String, completion: @escaping (_ result: String)->()) {
        self.parameters = parameters
        self.route = route
        completion("{\"token\":\"MockServerConnection\"}")
    }
    
    
    
    
}
