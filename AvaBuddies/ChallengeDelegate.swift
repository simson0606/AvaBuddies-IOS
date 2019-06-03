//
//  ChallengeDelegate.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 24/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

protocol ChallengeDelegate {
    func challengeListReceived(challenges: [Challenge])
    func failed()
}
