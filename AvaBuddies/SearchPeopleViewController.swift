//
//  SearchPeopleViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 05/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class SearchPeopleViewController: UITableViewController, UISearchResultsUpdating, UserListDelegate {

    var people = [User]()
    var fileredPeople = [User]()
    var resultSearchController = UISearchController()
    
    var userRepository: UserRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.title = "Search people".localized()
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        userRepository?.userListDelegate = self
        userRepository?.getUserList()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return fileredPeople.count
        } else {
            return people.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)

        if (resultSearchController.isActive) {
            cell.textLabel?.text = fileredPeople[indexPath.row].name
            cell.detailTextLabel?.text = fileredPeople[indexPath.row].email
            return cell
        }
        else {
            cell.textLabel?.text = people[indexPath.row].name
            cell.detailTextLabel?.text = people[indexPath.row].email
            return cell
        }
    }
 

    func updateSearchResults(for searchController: UISearchController) {
        fileredPeople.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (people as NSArray).filtered(using: searchPredicate)
        fileredPeople = array as! [User]
        
        self.tableView.reloadData()
    }
    
    func userListReceived(users: [User]) {
        people = users
        self.tableView.reloadData()
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
