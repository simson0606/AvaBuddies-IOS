//
//  LoginViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 18/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, MSALClientDelegate, LoginDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    var msalClient: MSALClient?
    var authenticationRepository: AuthenticationRepository?
    var firstStart = true
    
    override func viewDidLoad() {
        msalClient?.authenticationDelegate = self
        authenticationRepository?.loginDelegate = self
        
        logoImage.image = SvgFileLoader.getUIImageFrom(resource: Constants.logoOnly, size: logoImage.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if firstStart {
            firstStart = false
            msalClient?.signIn()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func manualLoginButtonTapped(_ sender: Any) {
        msalClient?.signIn()
    }
    
    func receivedUserInfo(userinfo: GraphUser) {
        authenticationRepository?.login(with: userinfo.userPrincipalName!)
    }
    
    func loggedIn() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoginCompletedSegue", sender: self)
        }
    }
    func signedOut() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
