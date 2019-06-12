//
//  ChallengeRepository.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 24/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ChallengeRepository {
    var serverConnection: ServerConnectionProtocol!
    
    var challenges: [Challenge]?
    
    var challengeDelegate: ChallengeDelegate?
    
    func getChallengeList(refresh: Bool = false){
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.ChallengeListRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ChallengeListResponse.self, from: result)
                self.challenges = response.challenges
                self.challengeDelegate?.challengeListReceived(challenges: self.challenges!)
            } catch {
                self.challengeDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.challengeDelegate?.failed()
        })
    }
}
