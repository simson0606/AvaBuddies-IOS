//
//  LoginViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 18/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, MSALClientDelegate {
    @IBOutlet weak var logoImage: UIImageView!
    
    private let msalClient = MSALClient()
    
    override func viewDidLoad() {
        msalClient.authenticationDelegate = self

        logoImage.image = SvgFileLoader.getUIImageFrom(resource: Constants.logoOnly, size: logoImage.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        msalClient.signIn()
    }
    
    @IBAction func manualLoginButtonTapped(_ sender: Any) {
        msalClient.signIn()
    }
    
    func receivedUserInfo(userinfo: GraphUser) {
        performSegue(withIdentifier: "LoginCompletedSegue", sender: self)
    }
}
