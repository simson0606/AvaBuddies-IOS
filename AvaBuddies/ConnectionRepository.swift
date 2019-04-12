//
//  FriendsRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ConnectionRepository {
    
    var serverConnection: ServerConnectionProtocol?
    
    var connectionDelegate: ConnectionDelegate?
    
    var connections: [Connection]?
    
    func connectionExists(with user: User) -> Bool{
        return connections?.filter{element in
            return element.friend1 == user._id || element.friend2 == user._id
            }.count ?? 0 > 0
    }
    
    func getConnectionList(refresh: Bool = false) {
        if connections != nil && !refresh {
            self.connectionDelegate?.connectionsReceived(connections: self.connections!)
            return
        }
        serverConnection?.request(parameters: nil, to: Constants.ServerConnection.ConnectionListRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let connectionsResponse = try decoder.decode(ConnectionsResponse.self, from: result)
                self.connections = connectionsResponse.connections
                self.connectionDelegate?.connectionsReceived(connections: self.connections!)
            } catch {
                self.connectionDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    func requestConnection(with user: User) {
        let parameters = ["friend": user._id]
        
        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.RequestConnectionRoute, with: .post, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()

        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    
    func cancelConnection(with user: User) {
        let parameters = ["friend": user._id]
        
        serverConnection?.request(parameters: parameters, to: Constants.ServerConnection.CancelRequestConnectionRoute, with: .post, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()
            
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
}
