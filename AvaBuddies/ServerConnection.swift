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
    
    func post(parameters: [String : Any], to route: String, completion: @escaping (_ result: String)->()) {
        Alamofire.request(Constants.ServerConnection.BaseURL + route, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(String(data: response.data!, encoding: .utf8)!)
            case .failure(let error):
                print(error)
            }
        }

    }

}
