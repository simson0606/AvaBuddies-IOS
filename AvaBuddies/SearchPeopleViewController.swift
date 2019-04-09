//
//  SearchPeopleViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 05/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class SearchPeopleViewController: UITableViewController, UISearchResultsUpdating, UserListDelegate, UserDelegate {
    

    var people = [User]()
    var filteredPeople = [User]()
    var resultSearchController = UISearchController()
    var selectedPerson: User?
    var userRepository: UserRepository?

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
        userRepository?.getUserList(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.title = "Search people".localized()

        userRepository?.userListDelegate = self
        userRepository?.userDelegate = self
        userRepository?.getUserList()
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
        
        filteredPeople = people.filter { result in
            return result.name.contains(searchController.searchBar.text!)
        }

        self.tableView.reloadData()
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
            publicProfileViewController.profile = selectedPerson
        }
    }
    
    func userListReceived(users: [User]) {
        userRepository?.getUser()
    }
    
    func userReceived(user: User) {
        self.refreshControl!.endRefreshing()

        if userRepository?.users != nil && userRepository?.user != nil {
            people = (userRepository?.users!.filter {user in
                return user._id != userRepository?.user?._id
                })!
            self.tableView.reloadData()
        }
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
