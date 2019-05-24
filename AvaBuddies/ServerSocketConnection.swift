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

    private var onList = [String]()
    
    private func startListening(){
        manager = SocketManager(socketURL: URL(string: Constants.ServerConnection.BaseURL)!, config: [.log(false), .compress])
        manager.reconnects = false
        
        socket = manager.defaultSocket
    }
    
    private func on() {
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.connectionDelegate?.connectionEstablished()
        }
        socket?.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
            self.off()
            self.connect()
        }
    }
    
    private func off(){
        onList.forEach() {item in
            socket?.off(item)
        }
        onList = [String]()
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
            print("Received message \(cur) from \(event)")
            self.messageDelegate?.receivedMessage(message: cur)
        }
    }
    
    func setUserOnline(id: String) {
        self.socket?.emit("user online", id)
    }
    
    func send(to event: String, with message: String){
        print("Sent message \(message) to \(event)")
        socket?.emit(event, message)
    }
}
