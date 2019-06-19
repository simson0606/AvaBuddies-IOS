//
//  ServerConnectionProtocol.swift
//  AvaBuddies
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import Alamofire

protocol ServerConnectionProtocol {
    
    func request(parameters: [String : Any]?, to route: String, with method: HTTPMethod,  completion: @escaping (_ result: Data)->(), fail: ((_ result: Data)->())?)
}
