//
//  TagRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 16/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class TagRepository {
    
    var serverConnection: ServerConnectionProtocol!

    var tags: [Tag]?

    var tagDelegate: TagDelegate?
    
    func getTagList(refresh: Bool = false){
//        if tags != nil && !refresh {
//            self.tagDelegate?.tagListReceived(tags: self.tags!)
//            return
//        }
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.TagListRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TagListResponse.self, from: result)
                self.tags = response.tags
                self.tagDelegate?.tagListReceived(tags: self.tags!)
            } catch {
                self.tagDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.tagDelegate?.failed()
        })
    }
}
