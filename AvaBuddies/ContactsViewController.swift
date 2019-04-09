//
//  ContactsViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 09/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import Localize_Swift

class ContactsViewController: UITableViewController, UserListDelegate, ConnectionDelegate {
 
    var selectedPerson: User?
    var userRepository: UserRepository?
    var connectionRepository: ConnectionRepository?
    
    override func viewDidLoad() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.title = "Contacts".localized()

        connectionRepository?.connectionDelegate = self
        userRepository?.userListDelegate = self
        
        userRepository?.getUserList()
    }
    
    @objc private func refreshData(_ sender: Any) {
        userRepository?.getUserList(refresh: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return connectionRepository?.receivedConnections?.count ?? 0
        } else {
            return connectionRepository?.sentConnections?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Received requests".localized()
        } else {
            return "Sent requests".localized()
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        if indexPath.section == 0 {
            let user = userRepository?.getUserBy(id: (connectionRepository?.receivedConnections?[indexPath.row].friend1)!)
            cell.textLabel?.text =  user?.name
            cell.detailTextLabel?.text = user?.email
            cell.imageView?.image = user?.getUIImage() ?? UIImage(named: "default_profile")
            
        } else {
            let user = userRepository?.getUserBy(id: (connectionRepository?.sentConnections?[indexPath.row].friend2)!)
            cell.textLabel?.text =  user?.name
            cell.detailTextLabel?.text = user?.email
            cell.imageView?.image = user?.getUIImage() ?? UIImage(named: "default_profile")
        }
        
        return cell
    }
    
    func userListReceived(users: [User]) {
        connectionRepository?.getRecevedSentConnectionList(refresh: true)
    }

    func connectionsReceived(connections: [Connection]) {
        self.refreshControl!.endRefreshing()
        tableView.reloadData()
    }
    
    func requestUpdated() {
        userRepository?.getUserList(refresh: true)
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedPerson = userRepository?.getUserBy(id: (connectionRepository?.receivedConnections?[indexPath.row].friend1)!)
        } else {
            selectedPerson = userRepository?.getUserBy(id: (connectionRepository?.sentConnections?[indexPath.row].friend2)!)
        }
        performSegue(withIdentifier: "viewProfilesegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PublicProfileViewController {
            let publicProfileViewController = segue.destination as! PublicProfileViewController
            publicProfileViewController.friend = selectedPerson
        }
    }
    

}
