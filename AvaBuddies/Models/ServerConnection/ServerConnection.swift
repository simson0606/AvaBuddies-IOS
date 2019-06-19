//
//  ServerConnection.swift
//  AvaBuddies
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import Alamofire

class ServerConnection : ServerConnectionProtocol {
    
    let sessionManager = SessionManager()
    
    init(accessTokenAdapter: AccessTokenAdapter) {
        sessionManager.adapter = accessTokenAdapter
    }
    
    func request(parameters: [String : Any]?, to route: String, with method: HTTPMethod,  completion: @escaping (_ result: Data)->(), fail: ((_ result: Data)->())? = nil) {
        
        sessionManager.request(Constants.ServerConnection.BaseURL + route, method: method, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(response.data!)
            case .failure:
                fail?(response.data ?? Data())
            }
        }
    }

}
