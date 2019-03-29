//
//  AccessTokenAdapter.swift
//  AvaBuddies
//
//  Created by simon heij on 28/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Constants.ServerConnection.BaseURL) {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
