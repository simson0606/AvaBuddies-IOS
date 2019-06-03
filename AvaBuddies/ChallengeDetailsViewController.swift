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
    
    var challenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        challengeTitle.text = challenge?.title
        challengeDescription.text = challenge?.description
        if !challenge!.image.isEmpty {
            if let imageData = Data(base64Encoded: challenge!.image, options: .ignoreUnknownCharacters) {
               imageView.image = UIImage(data: imageData)
            }
            else {
               imageView.image = UIImage(imageLiteralResourceName: "AppIcon")
            }
        }

    }

    
}
