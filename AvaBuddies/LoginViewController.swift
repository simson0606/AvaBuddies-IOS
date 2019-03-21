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
    
    var msalClient: MSALClient?
    var firstStart = true
    
    override func viewDidLoad() {
        msalClient?.authenticationDelegate = self

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
