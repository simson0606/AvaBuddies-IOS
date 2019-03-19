//
//  LoginViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 18/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, MSALClientDelegate {

    private let msalClient = MSALClient()
    
    override func viewDidLoad() {
        msalClient.authenticationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        msalClient.signIn()
    }
    
    func receivedUserInfo(userinfo: GraphUser) {
        performSegue(withIdentifier: "LoginCompletedSegue", sender: self)
    }
}
