//
//  MockServerConnection.swift
//  AvaBuddiesTests
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import Alamofire
@testable import AvaBuddies

class MockServerConnection: ServerConnectionProtocol {
    
    var response = ""
    var success = false
    
    var parameters: [String: Any]?
    var route: String?
    var method: HTTPMethod?
    
    
    func setMockResponse(response: String, success: Bool){
        self.response = response
        self.success = success
    }
    
    
    func request(parameters: [String : Any]?, to route: String, with method: HTTPMethod, completion: @escaping (Data) -> (), fail: ((Data) -> ())?) {
        self.parameters = parameters
        self.route = route
        if success {
            completion(response.data(using: .utf8)!)
        } else {
            fail!(response.data(using: .utf8)!)
        }
    }

}
