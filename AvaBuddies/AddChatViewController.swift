//
//  AddChatViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 24/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import Localize_Swift

class AddChatViewController: UITableViewController, UserListDelegate, UserDelegate, ChatDelegate {
    
    var people: [User]?
    var userRepository: UserRepository!
    var chatRepository: ChatRepository!
    override func viewDidAppear(_ animated: Bool) {
        
        userRepository.userListDelegate = self
        userRepository.userDelegate = self
        chatRepository.chatDelegate = self
        chatRepository.getChatList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem?.title = "Cancel".localized()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        cell.imageView?.image = people![indexPath.row].getUIImage() ?? UIImage(named: "default_profile")
        cell.textLabel?.text = people![indexPath.row].name

        return cell
    }
 
    func chatsReceived(chats: [Chat]) {
        userRepository.getUserList()
    }
    
    func userListReceived(users: [User]) {
        userRepository?.getUser(refresh: true)
    }
    
    func userReceived(user: User) {        
        if userRepository.users != nil && userRepository.user != nil {
            people = (userRepository.users!.filter {user in
                return user != userRepository.user && !chatRepository.userIsInChat(user: user)
            })
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatRepository.addChat(with: userRepository.user!, and: people![indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        //todo
    }
    
    
}
