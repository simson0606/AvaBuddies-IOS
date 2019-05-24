//
//  ChallengeViewController.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 24/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class ChallengeViewController: UITableViewController, ChallengeDelegate {

    var challengeRepository: ChallengeRepository!
    var filteredChallenges = [Challenge]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        challengeRepository.challengeDelegate = self
        challengeRepository.getChallengeList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeRepository.challenges?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell") as! ChallengeViewCell
        
        let challenge = challengeRepository.challenges![indexPath.row]
        
        cell.titleLabel.text = challenge.title
        cell.subtitleLabel.text = challenge.description
        cell.challengeImageView.image = UIImage(imageLiteralResourceName: "AppIcon")
        
        return cell
    }
    
    func challengeListReceived(challenges: [Challenge]) {
        tableView.reloadData()
    }
    
    func failed() {
        //nothing
    }

}
