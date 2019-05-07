
//
//  ChatViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 23/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class ChatViewController: MessagesViewController, UserDelegate, ChatMessageDelegate, MessagesDisplayDelegate, MessageInputBarDelegate, MessagesDataSource, MessagesLayoutDelegate {
    

    var userRepository: UserRepository!
    var chatMessageRepository: ChatMessageRepository!
    var chat: Chat?
    var messages: [ChatMessage] = []
    var section = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        chatMessageRepository.messageReceived(message: ChatMessage(_id: UUID().uuidString, chat: chat!, senderId: userRepository.user!._id, message: "testme \(Date())"))
        chatMessageRepository.messageReceived(message: ChatMessage(_id: UUID().uuidString, chat: chat!, senderId: (chat?.getOtherUser(me: userRepository.user!)._id)!, message: "testother \(Date())"))
        
        messages = chatMessageRepository.getMessages(for: chat!, section: 0)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func messageReceived(message: ChatMessage) {
        
    }
    
    func userReceived(user: User) {
        
    }
    
    func userDeleted() {
        
    }
    
    func failed() {
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 10 {
            let newMessages = chatMessageRepository.getMessages(for: chat!, section: section)
            if newMessages.count > 0 {
                section += 1

                messages.insert(contentsOf: newMessages, at: 0)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
    
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        let message = ChatMessage(_id: UUID().uuidString, chat: chat!, senderId: userRepository.user!._id, message: inputBar.inputTextView.text)
        chatMessageRepository.sendMessage(message: message)
        inputBar.inputTextView.text = ""
        section = 1
        messages = chatMessageRepository.getMessages(for: chat!, section: 0)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: userRepository.user!._id, displayName: userRepository.user!.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}
