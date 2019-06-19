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
    var method: String?
    
    
    func setMockResponse(response: String, success: Bool){
        self.response = response
        self.success = success
    }
    
    
    func request(parameters: [String : Any]?, to route: String, with method: HTTPMethod, completion: @escaping (Data) -> (), fail: ((Data) -> ())?) {
        self.parameters = parameters
        self.route = route
        switch method {
        case .options:
            self.method = "options"
        case .get:
            self.method = "get"
        case .head:
            self.method = "head"
        case .post:
            self.method = "post"
        case .put:
            self.method = "put"
        case .patch:
            self.method = "patch"
        case .delete:
            self.method = "delete"
        case .trace:
            self.method = "trace"
        case .connect:
            self.method = "connect"
        }
        if success {
            completion(response.data(using: .utf8)!)
        } else {
            fail!(response.data(using: .utf8)!)
        }
    }

}
