//
//  TabBarViewController.swift
//  AvaBuddies
//
//  Created by simon heij on 21/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.selectedIndex = 0
    }
}
