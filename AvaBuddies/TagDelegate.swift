//
//  TagDelegate.swift
//  AvaBuddies
//
//  Created by simon heij on 16/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol TagDelegate {
    func tagListReceived(tags: [Tag])
    func failed()
}
