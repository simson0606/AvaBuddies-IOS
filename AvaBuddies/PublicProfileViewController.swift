//
//  PublicProfileViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 08/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class PublicProfileViewController: UITableViewController, UserDelegate, ConnectionDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var aboutmelabel: UITextView!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var tagsCollectionFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            tagsCollectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    var userRepository: UserRepository?
    var connectionRepository: ConnectionRepository?
    
    var friend: User?
    
    var connectionConfirmed = false;
    override func viewDidLoad() {
        tagsCollection.dataSource = self
        tagsCollection.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagView")
    }
    
    
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
            connectionConfirmed = connectionRepository!.connectionConfirmed(with: userRepository!.user!, and: friend!)
            let hideItems = friend?.isPrivate ?? false && !connectionConfirmed

            if indexPath.row == 1 {
                return !connectionExists && !connectionConfirmed ? 44 : 0
            }
            if indexPath.row == 2 {
                return connectionIsSent && !connectionConfirmed ? 44 : 0
            }
            if indexPath.row == 3 {
                return connectionIsReceived && !connectionConfirmed ? 44 : 0
            }
            if (indexPath.row == 6) {
                return hideItems ? 0 : 148
            }
            if (indexPath.row == 7) {
                return hideItems ?  44 : 0
            }
            if (indexPath.row == 8) {
                return hideItems ? 0 : 136
            }
        }
        if indexPath.row == 0 {
            return 276
        }
    
        if indexPath.row == 3 || indexPath.row == 2 || indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8{
            return 0
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
        tagsCollection.reloadData()
        tagsCollection.invalidateIntrinsicContentSize()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friend?.tags?.filter {$0.isPrivate == false }.count ?? 0
        if connectionConfirmed {
             return friend?.tags?.count ?? 0
        } else {
            return friend?.tags?.filter {$0.isPrivate == false }.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagView", for: indexPath as IndexPath) as! TagCollectionViewCell
        
        if connectionConfirmed {
            cell.nameLabel.text = friend?.tags![indexPath.row].name
        } else {
            cell.nameLabel.text = friend?.tags!.filter {$0.isPrivate == false }[indexPath.row].name
        }
        return cell
    }
}
