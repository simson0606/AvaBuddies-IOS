//
//  GraphUser.swift
//  AvaBuddies
//
//  Created by simon heij on 19/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct GraphUser : Codable {
    var displayName : String?
    var givenName : String?
    var id : String?
    var jobTitle : String?
    var mail : String?
    var mobilePhone : String?
    var officeLocation : String?
    var preferredLanguage : String?
    var surname : String?
    var userPrincipalName : String?
}
