//
//  AccountViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 21/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import Localize_Swift

class ProfileViewController: UITableViewController, UserDelegate {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var shareLocationToggle: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var msalClient: MSALClient?
    var userRepository: UserRepository?
    
    override func viewDidLoad() {
        userRepository?.userDelegate = self
        userRepository?.getUser()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        parent?.title = "Profile".localized()
        parent?.navigationItem.setRightBarButton(saveButton, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        parent?.navigationItem.setRightBarButton(nil, animated: false)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        aboutMeText.resignFirstResponder()
    }

    func userReceived(user: User) {
        self.profileImage.image = user.getUIImage()
        self.nameLabel.text = user.name
        self.mailLabel.text = user.email
        self.aboutMeText.text = user.aboutme
        self.shareLocationToggle.isOn = user.sharelocation

    }
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.profileImage.image = image
            self.userRepository?.user?.setImage(image: image)
            self.userRepository?.updateProfileImage()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        userRepository?.user?.aboutme = aboutMeText.text
        userRepository?.updateProfile()
    }
    
    @IBAction func shareLocationToggled(_ sender: UISwitch) {
        userRepository?.user?.sharelocation = sender.isOn
        userRepository?.updateProfile()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        msalClient?.signOut()
    }
}
