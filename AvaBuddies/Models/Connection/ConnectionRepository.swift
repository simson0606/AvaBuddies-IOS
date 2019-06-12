//
//  FriendsRepository.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ConnectionRepository {
    
    var serverConnection: ServerConnectionProtocol!
    
    var connectionDelegate: ConnectionDelegate?
    
    var sentConnections: [Connection]?
    var receivedConnections: [Connection]?
    
    var connections: [Connection]?
    
    func connectionExists(with user: User, and friend: User) -> Bool{
        return connections?.filter{element in
            return (element.user == user._id && element.friend == friend._id) ||
                    (element.user == friend._id && element.friend == user._id)
            }.count ?? 0 > 0
    }
    
    func connectionIsReceived(with user: User, and friend: User) -> Bool{
        return connections?.filter{element in
            return element.user == friend._id && element.friend == user._id
            }.count ?? 0 > 0
    }
    
    func connectionIsSent(with user: User, and friend: User) -> Bool{
        return connections?.filter{element in
            return element.user == user._id && element.friend == friend._id
            }.count ?? 0 > 0
    }
    
    func connectionValidated(with user: User, and friend: User) -> Bool {
        return connections?.filter{element in
            return element.user == friend._id && element.friend == user._id && element.validated
            }.count ?? 0 > 0
    }
    
    func connectionConfirmed(with user: User, and friend: User) -> Bool {
        return connections?.filter{element in
            return (element.user == friend._id && element.friend == user._id && element.validated && element.confirmed) ||
                    (element.user == user._id && element.friend == friend._id && element.validated && element.confirmed)
            }.count ?? 0 > 0
    }
    
    func getConnectionList(refresh: Bool = false) {
        if connections != nil && !refresh {
            self.connectionDelegate?.connectionsReceived(connections: self.connections!)
            return
        }
        serverConnection.request(parameters: nil, to: Constants.ServerConnection.FriendsRoute, with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let connectionsResponse = try decoder.decode(ConnectionsResponse.self, from: result)
                self.connections = connectionsResponse.friends
                self.connectionDelegate?.connectionsReceived(connections: self.connections!)
            } catch {
                self.connectionDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    func getRecevedSentConnectionList(refresh: Bool = false, userId: String) {
        if sentConnections != nil && !refresh {
            self.connectionDelegate?.connectionsReceived(connections: self.receivedConnections!)
            return
        }
        serverConnection.request(parameters: nil, to: "\(Constants.ServerConnection.FriendsRoute)/\(userId)", with: .get, completion: {
            (result) -> () in
            let decoder = JSONDecoder()
            do {
                let connectionsResponse = try decoder.decode(RequestsResponse.self, from: result)
                self.sentConnections = connectionsResponse.own_requests
                self.receivedConnections = connectionsResponse.requests
                self.connectionDelegate?.connectionsReceived(connections: self.receivedConnections!)
            } catch {
                self.connectionDelegate?.failed()
            }
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    func requestConnection(with user: User) {
        let parameters = ["id": user._id]
        
        serverConnection.request(parameters: parameters, to: Constants.ServerConnection.FriendsRoute, with: .post, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()

        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    
    func cancelConnection(with user: User) {
        serverConnection.request(parameters: nil, to: "\(Constants.ServerConnection.FriendsRoute)/\(user._id)", with: .delete, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()
            
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    func denyConnection(with user: User) {
        cancelConnection(with: user)
    }
    
    func acceptConnection(with user: User) {
        let parameters = ["type": "accept"]

        serverConnection.request(parameters: parameters, to: "\(Constants.ServerConnection.FriendsRoute)/\(user._id)", with: .put, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()
            
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
    
    func validateConnection(with id: String) {
        let parameters = ["type": "validate"]

        serverConnection.request(parameters: parameters, to: "\(Constants.ServerConnection.FriendsRoute)/\(id)", with: .put, completion: {
            (result) -> () in
            self.connectionDelegate?.requestUpdated()
            
        }, fail: {
            (result) -> () in
            self.connectionDelegate?.failed()
        })
    }
}
