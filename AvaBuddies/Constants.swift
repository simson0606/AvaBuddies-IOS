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
        static let ClientID = "cb6d5283-741e-4dc4-8cb2-e73d03629ced"
        
        // These settings you don't need to edit unless you wish to attempt deeper scenarios with the app.
        static let GraphURI = "https://graph.microsoft.com/v1.0/me/"
        static let Scopes: [String] = ["https://graph.microsoft.com/user.read"]
        static let Authority = "https://login.microsoftonline.com/common"
    }
    
    struct ServerConnection {
        static let BaseURL = "https://dev.avabuddies.nl"
        static let RegisterRoute = "/auth/register"
        static let LoginRoute = "/auth/login"
        static let UserProfileRoute = "/user/profile"
        static let UpdateProfileImageRoute = "/user/updateprofilepicture"
        static let UpdateProfileRoute = "/user/updateprofile"
        static let DeleteProfileRoute = "/user/destroy/"
        static let UserListRoute = "/user/list"
        static let ConnectionListRoute = "/friend/allconnections"
        static let RequestConnectionRoute = "/friend/request"
        static let CancelRequestConnectionRoute = "/friend/cancelrequest"
        static let DenyRequestConnectionRoute = "/friend/denyrequest"
        static let AcceptRequestConnectionRoute = "/friend/acceptrequest"
        static let ValidateRequestConnectionRoute = "/friend/validaterequest"
        static let ConnectionRequestsRoute = "/friend/requests"
        static let Secret = "SamplePassword"
    }
    
    static let logoOnly = ResourceFile(filename: "avanade-logo-only", filetype: "svg")
    
    static let QrValidSeconds = 3

}


