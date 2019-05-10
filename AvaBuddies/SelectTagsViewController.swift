//
//  SelectTagsViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 16/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class SelectTagsViewController: UITableViewController, UISearchResultsUpdating, TagDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var tagSearchController = UISearchController()
    var userRepository: UserRepository!
    var tagRepository: TagRepository!
    var selectedTags = [Tag]()
    var filteredTags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tagRepository.tagDelegate = self
        tagRepository.getTagList()
        navigationItem.setRightBarButton(saveButton, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.setRightBarButton(nil, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (tagSearchController.isActive) {
            return filteredTags.count
        }
        return tagRepository.tags?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)

        if (tagSearchController.isActive) {
            cell.textLabel?.text = filteredTags[indexPath.row].name
            return cell
        }
        cell.textLabel?.text = tagRepository.tags![indexPath.row].name
        let selected = selectedTags.contains { tag in
            tag._id == tagRepository.tags![indexPath.row]._id
        }
        cell.accessoryType = selected ? .checkmark : .none
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedTags.firstIndex(of: tagRepository.tags![indexPath.row]) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tagRepository.tags![indexPath.row])
        }
        tableView.reloadData()
    }
    
    func tagListReceived(tags: [Tag]) {
        selectedTags = userRepository.user?.tags ?? [Tag]()
        tableView.reloadData()
    }
    
    func failed() {
        //nothing
    }

    @IBAction func saveTapped(_ sender: Any) {
        userRepository.user?.tags = selectedTags
        userRepository.updateProfile()
        navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let tags = tagRepository.tags, let text = searchController.searchBar.text {
            if text.isEmpty {
                filteredTags = tags
            } else {
                filteredTags = tags.filter {$0.name.contains(text)}
            }
        }
        self.tableView.reloadData()
    }
}
