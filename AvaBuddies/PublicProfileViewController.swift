//
//  PublicProfileViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class PublicProfileViewController: UITableViewController, ConnectionDelegate {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var aboutmelabel: UITextView!
    
    var connectionRepository: ConnectionRepository?
    
    var profile: User?
    
    override func viewWillAppear(_ animated: Bool) {
        if profile?.getUIImage() != nil {
            profileImage.image = profile?.getUIImage()
        }
        nameLabel.text = profile?.name
        mailLabel.text = profile?.email
        aboutmelabel.text = profile?.aboutme
        
        connectionRepository?.connectionDelegate = self
        connectionRepository?.getConnectionList()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let connectionExists = connectionRepository!.connectionExists(with: profile!)
        let connectionIsReceived = connectionRepository!.connectionIsReceived(with: profile!)
        let connectionIsSent = connectionRepository!.connectionIsSent(with: profile!)

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
            return connectionIsReceived ? 44 : 0
        }
        if (indexPath.row == 6) {
            return 148
        }
        return 44
        
    }
    
    @IBAction func sendConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.requestConnection(with: profile!)
    }
    
    @IBAction func cancelConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.cancelConnection(with: profile!)
    }
    
    @IBAction func DenyConnectionRequestTapped(_ sender: Any) {
        connectionRepository?.denyConnection(with: profile!)
    }
    
    
    func connectionsReceived(connections: [Connection]) {
        tableView.reloadData()
    }
    
    func requestUpdated() {
        connectionRepository?.getConnectionList(refresh: true)
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QRFriendRequestViewController {
            let publicProfileViewController = segue.destination as! QRFriendRequestViewController
            publicProfileViewController.profile = profile
        }
    }
    
}
