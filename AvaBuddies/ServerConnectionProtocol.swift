//
//  ServerConnectionProtocol.swift
//  AvaBuddies
//
//  Created by simon heij on 26/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol ServerConnectionProtocol {
    func post(parameters: [String: Any], to route: String, completion: @escaping (_ result: String)->())
}
