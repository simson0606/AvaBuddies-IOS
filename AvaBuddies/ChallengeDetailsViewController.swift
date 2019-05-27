//
//  ChallengeDetailsViewController.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 27/05/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class ChallengeDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(imageLiteralResourceName: "AppIcon")
        challengeTitle.text = "Lange challenge titel jongen"
        challengeDescription.text = "Deze challenge lorem ipsum. We vaganen abersotie in de kasafoncus do drago. Apa sita confiktus aba blanka ronsko itunskinini aber denski"
    }

}
