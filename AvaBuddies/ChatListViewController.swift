//
//  ChatListViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 23/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController, ChatDelegate, UserDelegate {

    @IBOutlet weak var addChatButton: UIBarButtonItem!
    

    var userRepository: UserRepository!
    var chatRepository: ChatRepository!
    
    override func viewDidAppear(_ animated: Bool) {
        parent?.title = "Chat".localized()
        parent?.navigationItem.setRightBarButton(addChatButton, animated: false)
        userRepository.userDelegate = self
        chatRepository.chatDelegate = self
        userRepository.getUser(refresh: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        parent?.navigationItem.setRightBarButton(nil, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRepository.chats?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        let chat = chatRepository.chats![indexPath.row]
        let otherPerson = chat.getOtherUser(me: userRepository.user!)
        
        cell.imageView?.image = otherPerson.getUIImage() ?? UIImage(named: "default_profile")
        cell.textLabel?.text = otherPerson.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            chatRepository.removeChat(chat: chatRepository.chats![indexPath.row])
            chatRepository.getChatList()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    
    func chatsReceived(chats: [Chat]) {
        tableView.reloadData()
    }
    
    func userReceived(user: User) {
        chatRepository.getChatList()
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        //todo
    }
    
}
