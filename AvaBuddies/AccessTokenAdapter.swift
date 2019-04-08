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
    
    var accessToken: String?
    
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if accessToken != nil, let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Constants.ServerConnection.BaseURL) {
            urlRequest.setValue("Bearer " + accessToken!, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
