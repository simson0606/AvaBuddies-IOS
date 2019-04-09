//
//  PublicProfileViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class PublicProfileViewController: UITableViewController, UserDelegate, ConnectionDelegate {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var aboutmelabel: UITextView!
    
    var userRepository: UserRepository?
    var connectionRepository: ConnectionRepository?
    
    var friend: User?
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.image = friend?.getUIImage() ?? UIImage(named: "default_profile")
        
        nameLabel.text = friend?.name
        mailLabel.text = friend?.email
        aboutmelabel.text = friend?.aboutme
        
        userRepository?.userDelegate = self
        userRepository?.getUser()
        connectionRepository?.connectionDelegate = self
        connectionRepository?.getConnectionList(refresh: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if userRepository?.user != nil && friend != nil {
            let connectionExists = connectionRepository!.connectionExists(with: userRepository!.user!, and: friend!)
            let connectionIsReceived = connectionRepository!.connectionIsReceived(with: userRepository!.user!, and: friend!)
            let connectionIsSent = connectionRepository!.connectionIsSent(with: userRepository!.user!, and: friend!)
            let connectionIsConfirmed = connectionRepository!.connectionConfirmed(with: userRepository!.user!, and: friend!)
            
            if indexPath.row == 0 {
                return 276
            }
            if indexPath.row == 1 {
                return connectionExists ? 0 : 44
            }
            if indexPath.row == 2 {
                return connectionIsSent ? 44 : 0
            }
            if indexPath.row == 3 {
                return connectionIsReceived && !connectionIsConfirmed ? 44 : 0
            }
            if (indexPath.row == 6) {
                return 148
            }
        }
        return 44
        
    }
    
    @IBAction func sendConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.requestConnection(with: friend!)
    }
    
    @IBAction func cancelConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.cancelConnection(with: friend!)
    }
    
    @IBAction func DenyConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.denyConnection(with: friend!)
    }
    
    
    func connectionsReceived(connections: [Connection]) {
        tableView.reloadData()
    }
    
    func requestUpdated() {
        connectionRepository?.getConnectionList(refresh: true)
    }
    
    func userReceived(user: User) {
        tableView.reloadData()
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QRFriendRequestViewController {
            let publicProfileViewController = segue.destination as! QRFriendRequestViewController
            publicProfileViewController.friend = friend
        }
    }
    
}
