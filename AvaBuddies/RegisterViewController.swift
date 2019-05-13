//
//  RegisterViewController.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 11/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterDelegate, LoginDelegate {
   
    var msalClient: MSALClient?
    var userRepository: UserRepository?
    var authenticationRepository: AuthenticationRepository?
    var goingForwards = false
    
    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        authenticationRepository?.registerDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authenticationRepository?.loginDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (!goingForwards) {
            msalClient?.signOut()
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if let mail = msalClient?.userInfo?.userPrincipalName, let givenName = msalClient?.userInfo?.givenName , let surName =  msalClient?.userInfo?.surname {
            authenticationRepository?.register(with: mail, with: "\(givenName) \(surName)", location: locationSwitch.isOn)
        }
    }
    
    func register() {
        goingForwards = true
        if let mail = msalClient?.userInfo?.userPrincipalName {
            authenticationRepository?.login(with: mail)
        }
    }
    
    func registerFailed() {
        let alert = UIAlertController(title: "Cannot register".localized(), message: "Cannot register at this moment, please try again later".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { action in
            self.msalClient?.signOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loggedIn() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "RegisterCompletedSegue", sender: self)
        }
    }
    
    func loginFailed(message: FailedLoginResponse) {
        let alert = UIAlertController(title: "Cannot login".localized(), message: "Cannot login at this moment, please try again later".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { action in
            self.msalClient?.signOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
