
//
//  ChatViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 23/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController, UserDelegate, ChatMessageDelegate {

    var userRepository: UserRepository!
    var chatMessageRepository: ChatMessageRepository!
    var chat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatMessageRepository.test()
        
        // Do any additional setup after loading the view.
    }
    
    func messageReceived(message: ChatMessage) {
        
    }
    
    func userReceived(user: User) {
        
    }
    
    func userDeleted() {
        
    }
    
    func failed() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
