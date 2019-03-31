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
    
//    var accessTokenAdapter: AccessTokenAdapter?
    let sessionManager = SessionManager()
    
    init(accessTokenAdapter: AccessTokenAdapter) {
        sessionManager.adapter = accessTokenAdapter
    }
    
    func post(parameters: [String : Any], to route: String, completion: @escaping (_ result: Data)->()) {
        sessionManager.request(Constants.ServerConnection.BaseURL + route, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(response.data!)
            case .failure(let error):
                print(response)
                print(error)
            }
        }
    }
    
    func get(parameters: [String : Any]?, to route: String, completion: @escaping (Data) -> ()) {
        sessionManager.request(Constants.ServerConnection.BaseURL + route, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(response.data!)
            case .failure(let error):
                print(response)
                print(error)
            }
        }
    }

}
