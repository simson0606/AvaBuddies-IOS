//
//  ServerSocketConnectionProtocol.swift
//  AvaBuddies
//
//  Created by simon heij on 08/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import SocketIO

class ServerSocketConnection {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient?
    
    private func startListening(){
        manager = SocketManager(socketURL: URL(string: Constants.ServerConnection.BaseURL)!, config: [.log(true), .compress])
    }
    
    private func on() {
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
    }
    
    private func off(){
        socket?.off(clientEvent: .connect)

    }
}
