//
//  RegisterViewController.swift
//  AvaBuddies
//
//  Created by Bryan van Lierop on 11/04/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterDelegate, UserDelegate {
   
    var msalClient: MSALClient?
    var userRepository: UserRepository?
    var authenticationRepository: AuthenticationRepository?
    var goingForwards = false
    
    @IBOutlet weak var agreementSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        userRepository?.userDelegate = self
        userRepository?.getUser()
        authenticationRepository?.registerDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (!goingForwards) {
            msalClient?.signOut()
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if (agreementSwitch.isOn) {
            if let mail = msalClient?.userInfo?.userPrincipalName, let givenName = msalClient?.userInfo?.givenName , let surName =  msalClient?.userInfo?.surname {
                authenticationRepository?.register(with: mail, with: givenName + " " + surName, location: locationSwitch.isOn)
            }
        } else {
            let alert = UIAlertController(title: "Cannot register".localized(), message: "You need to accept the terms and conditions, before you can continue".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func register() {
        goingForwards = true
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "RegisterCompletedSegue", sender: self)
        }
    }
    
    func registerFailed() {
        let alert = UIAlertController(title: "Cannot register".localized(), message: "Cannot register at this moment, please try again later".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { action in
            self.msalClient?.signOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userReceived(user: User) {
        //
    }
    
    func userDeleted() {
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    


}
