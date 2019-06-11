//
//  AccountViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 21/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import Localize_Swift

class ProfileViewController: UITableViewController, UserDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var shareLocationToggle: UISwitch!
    @IBOutlet weak var makeProfilePrivate: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var tagsCollectionFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            tagsCollectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    var msalClient: MSALClient!
    var userRepository: UserRepository!

    override func viewDidLoad() {
        tagsCollection.dataSource = self
        tagsCollection.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userRepository.userDelegate = self
        userRepository?.getUser(refresh: true)
        parent?.title = "Profile".localized()
        parent?.navigationItem.setRightBarButton(saveButton, animated: false)
        tagsCollection.reloadData()
        tagsCollection.invalidateIntrinsicContentSize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        parent?.navigationItem.setRightBarButton(nil, animated: false)
    }

    func userReceived(user: User) {
        if (msalClient.userImage != nil) {
            profileImage.image = msalClient.userImage
        }
        if user.getUIImage() != nil {
            profileImage.image = user.getUIImage()
        }
        self.nameLabel.text = user.name
        self.mailLabel.text = user.email
        self.aboutMeText.text = user.aboutme
        self.shareLocationToggle.isOn = user.sharelocation
        self.makeProfilePrivate.isOn = user.isPrivate ?? false
        tagsCollection.reloadData()
        tagsCollection.invalidateIntrinsicContentSize()
    }
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            let croppedImage = image.resizeCropImage(targetSize: CGSize(width: 300, height: 300))
            
            self.profileImage.image = croppedImage
            self.userRepository.user?.setImage(image: croppedImage)
            self.userRepository.updateProfileImage()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        userRepository.user?.aboutme = aboutMeText.text
        userRepository.updateProfile()
    }
    
    @IBAction func shareLocationToggled(_ sender: UISwitch) {
        userRepository.user?.sharelocation = sender.isOn
        userRepository.updateProfile()
    }
    
    @IBAction func makeProfilePrivateToggled(_ sender: UISwitch) {
        userRepository?.user?.isPrivate = sender.isOn
        userRepository?.updateProfile()
    }
    @IBAction func deleteTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?".localized(), message: "Are you sure you want to permanantly delete your account? \nThis cannot be reversed!".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { action in
            self.userRepository.deleteProfile()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userDeleted() {
        logoutTapped(self)
    }
    
    func failed() {
        let alert = UIAlertController(title: "Failed".localized(), message: "Request failed".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userRepository.user?.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagView", for: indexPath as IndexPath) as! TagCollectionViewCell
        
        cell.nameLabel.text = userRepository.user!.tags![indexPath.row].name
        return cell
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        msalClient.signOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchPeopleViewController {
            let destination = segue.destination as! SearchPeopleViewController
            destination.friendsOnly = true
        }
    }
}
