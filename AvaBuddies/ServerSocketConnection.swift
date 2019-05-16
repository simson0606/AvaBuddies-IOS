//
//  ServerSocketConnection.swift
//  AvaBuddies
//
//  Created by simon heij on 08/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import SocketIO

class ServerSocketConnection: ServerSocketConnectionProtocol {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient?
    
    private var connectionDelegate: ServerSocketConnectionDelegate?
    private var messageDelegate: ServerSocketMessageDelegate?

    private func startListening(){
        manager = SocketManager(socketURL: URL(string: Constants.ServerConnection.BaseURL)!, config: [.log(true), .compress])
        manager.reconnects = true
        manager.reconnectWait = 5
        
        socket = manager.defaultSocket
    }
    
    private func on() {
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.connectionDelegate?.connectionEstablished()
        }
    }
    
    private func off(){
        socket?.off(clientEvent: .connect)
    }
    
    func connect(){
        startListening()
        on()
        socket?.connect()
    }
    
    func setConnectionDelegate(delegate: ServerSocketConnectionDelegate) {
        self.connectionDelegate = delegate
    }
    
    func setMessageDelegate(delegate: ServerSocketMessageDelegate) {
        self.messageDelegate = delegate
    }
    
    func listen(to event: String){
        socket?.on(event){data, ack in
            guard let cur = data[0] as? String else {
                return
            }
            self.messageDelegate?.receivedMessage(message: cur)
        }
    }
    
    func setUserOnline(id: String) {
        self.socket?.emit("user online", id)
    }
    
    func send(to event: String, with message: String){
        socket?.emit(event, message)
    }
}
