//
//  QRFriendRequestViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 09/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class QRFriendRequestViewController: UIViewController, UserDelegate, ConnectionDelegate {
    
    var friend: User?
    var userRepository: UserRepository?
    var connectionRepository: ConnectionRepository?
    var qrCodeGenerator = QRCodeGenerator()
    var timer: Timer?
    
    @IBOutlet weak var requestFromLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var creatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestFromLabel.text = String(format: "Friend request from %@".localized(), friend!.name)
        explanationLabel.text = String(format: "Let %@ scan this QR code".localized(), friend!.name)

        userRepository?.userDelegate = self
        connectionRepository?.connectionDelegate = self
        userRepository?.getUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func fireTimer() {
        if (userRepository?.user != nil) {
            let friendRequest = FriendRequest(dateTime: Date(), id: (userRepository?.user!._id)!)
            let jsonEncoder = JSONEncoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            jsonEncoder.dateEncodingStrategy = .formatted(formatter)
            let jsonData = try! jsonEncoder.encode(friendRequest)
            qrImageView.image = qrCodeGenerator.generateQRCode(from: jsonData)
            creatingLabel.isHidden = true
        } else {
            creatingLabel.isHidden = false
        }
        connectionRepository?.getConnectionList(refresh: true)
    }
    
    func userReceived(user: User) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.QrValidSeconds-1), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func connectionsReceived(connections: [Connection]) {
        if (connectionRepository?.connectionValidated(with: userRepository!.user!, and: friend!))! {
            connectionRepository?.acceptConnection(with: friend!)
        }
    }
    
    func requestUpdated() {
        navigationController?.popViewController(animated: true)
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        //nothing
    }
  

}
