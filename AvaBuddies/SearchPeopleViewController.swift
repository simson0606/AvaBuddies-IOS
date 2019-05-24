//
//  SearchPeopleViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 05/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class SearchPeopleViewController: UITableViewController, UISearchResultsUpdating, UserListDelegate, UserDelegate, ConnectionDelegate {
    

    var people = [User]()
    var filteredPeople = [User]()
    var resultSearchController = UISearchController()
    var selectedPerson: User?
    var userRepository: UserRepository!
    var connectionRepository: ConnectionRepository!
    var friendsOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        self.clearsSelectionOnViewWillAppear = false
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        tableView.reloadData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        userRepository.getUserList(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.title = "Search people".localized()

        userRepository.userListDelegate = self
        userRepository.userDelegate = self
        connectionRepository.connectionDelegate = self
        userRepository.getUserList()
    }

    override func viewWillDisappear(_ animated: Bool) {
        friendsOnly = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredPeople.count
        } else {
            return people.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)

        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredPeople[indexPath.row].name
            cell.detailTextLabel?.text = filteredPeople[indexPath.row].email
            cell.imageView?.image = filteredPeople[indexPath.row].getUIImage() ?? UIImage(named: "default_profile")
            
            return cell
        }
        else {
            cell.textLabel?.text = people[indexPath.row].name
            cell.detailTextLabel?.text = people[indexPath.row].email
            cell.imageView?.image = people[indexPath.row].getUIImage() ?? UIImage(named: "default_profile")
           
            return cell
        }
    }
 

    func updateSearchResults(for searchController: UISearchController) {
        filteredPeople.removeAll(keepingCapacity: false)
        
        filteredPeople = filterUsersByString(filterString: searchController.searchBar.text!)

        self.tableView.reloadData()
    }
    
    public func filterUsersByString(filterString: String) -> [User] {
        let keyWords = filterString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().components(separatedBy: " ")
        return people.filter { result in
            for keyWord in keyWords {
                if keyWord.isEmpty {
                    continue
                }
                if result.name.lowercased().contains(keyWord) {
                    continue
                }
                if result.email.lowercased().contains(keyWord) {
                    continue
                }
                if result.isPrivate == false, hasTag(user: result, tagFilter: keyWord) {
                    continue
                }
                return false
            }
            return true
        }
    }
    
    private func hasTag(user: User, tagFilter: String) -> Bool {
        if let tags = user.tags {
            for tag in tags {
                if tag.isPrivate == false && tag.name.lowercased().contains(tagFilter) {
                    return true
                }
            }
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  (resultSearchController.isActive) {
            selectedPerson = filteredPeople[indexPath.row]
        } else {
            selectedPerson = people[indexPath.row]
        }
        performSegue(withIdentifier: "viewProfilesegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PublicProfileViewController {
            let publicProfileViewController = segue.destination as! PublicProfileViewController
            publicProfileViewController.friend = selectedPerson
        }
    }
    
    func userListReceived(users: [User]) {
        userRepository.getUser(refresh: true)
    }
    
    func userReceived(user: User) {
        connectionRepository.getConnectionList(refresh: true)
    }
    
    func connectionsReceived(connections: [Connection]) {
        self.refreshControl!.endRefreshing()
        
        if userRepository.users != nil && userRepository.user != nil && connectionRepository.connections != nil {
            if friendsOnly {
                people = (userRepository.users!.filter {user in
                    return user._id != userRepository.user?._id && connectionRepository.connectionConfirmed(with: userRepository.user!, and: user)
                })
            } else {
                people = (userRepository.users!.filter {user in
                    return user._id != userRepository.user?._id
                })
            }
            
            self.tableView.reloadData()
        }
    }
    
    func requestUpdated() {
        //nothing
    }
    
    func userDeleted() {
        //nothing
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
