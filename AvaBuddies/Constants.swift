//
//  Constants.swift
//  AvaBuddies
//
//  Created by simon heij on 19/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

struct Constants {
    
    struct MSAL {
        // Update the below to your client ID you received in the portal.
//        static let ClientID = "cb6d5283-741e-4dc4-8cb2-e73d03629ced"
        static let ClientID = "1de0ccd6-b099-418b-adda-2248e0aeb325"

        // These settings you don't need to edit unless you wish to attempt deeper scenarios with the app.
        static let GraphURI = "https://graph.microsoft.com/beta/me/"
        static let PhotoRoute = "photo/$value"
        static let Scopes: [String] = ["https://graph.microsoft.com/user.read"]
        static let Authority = "https://login.microsoftonline.com/common"
    }
    
    struct ServerConnection {
        static let BaseURL = "https://www.avabuddies.nl"
        static let RegisterRoute = "/auth/signup"
        static let LoginRoute = "/auth/login"
        static let UsersRoute = "/users"
        static let ProfileSuffix = "/profile"
        static let FriendsRoute = "/friends"
        static let TagsRoute = "/tags"
        static let ChatRoute = "/chats"
        static let ChallengeListRoute = "/challenges"
        static let ChatAck = "messageAcked";
        static let Secret = "SamplePassword"
    }
    
    static let LocalStoragePageSize = 15
    
    static let logoOnly = ResourceFile(filename: "avanade-logo-only", filetype: "svg")
    
    static let QrValidSeconds = 10

}


