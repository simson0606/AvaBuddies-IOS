//
//  ChatListViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 23/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController, ChatDelegate, ChatListDelegate, UserDelegate {
    

    @IBOutlet weak var addChatButton: UIBarButtonItem!

    var userRepository: UserRepository!
    var chatRepository: ChatRepository!
    var chatMessageRepository: ChatMessageRepository!
    var selectedChat: Chat?
    
    override func viewDidLoad() {
        parent?.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        chatRepository.getChatList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        parent?.title = "Chat".localized()
        parent?.navigationItem.setRightBarButton(addChatButton, animated: false)
        userRepository.userDelegate = self
        chatRepository.chatDelegate = self
        chatRepository.chatListDelegate = self
        chatRepository.getChatList()
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
            chatMessageRepository.clear(for: chatRepository.chats![indexPath.row])
            chatRepository.removeChat(chat: chatRepository.chats![indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = chatRepository.chats![indexPath.row]
        performSegue(withIdentifier: "viewChat", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let chatViewController = segue.destination as? ChatViewController  {
            chatViewController.chat = selectedChat
        }
    }
    
    
    func chatsReceived(chats: [Chat]) {
        chatMessageRepository.purge(except: chats)
        self.refreshControl!.endRefreshing()
        tableView.reloadData()
    }
    
    func userReceived(user: User) {
        chatRepository.setUserOnline(user: user)
    }
    
    func loginRequested() {
        if let user = userRepository.user {
            print("login requested")
            chatRepository.setUserOnline(user: user)
        }
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        //todo
    }
    
}
