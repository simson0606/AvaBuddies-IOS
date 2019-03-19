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
        //    static let kClientID = "b58325a2-613b-4cdf-b0e0-5bc625084437"
        static let ClientID = "cb6d5283-741e-4dc4-8cb2-e73d03629ced"
        
        // These settings you don't need to edit unless you wish to attempt deeper scenarios with the app.
        static let GraphURI = "https://graph.microsoft.com/v1.0/me/"
        static let Scopes: [String] = ["https://graph.microsoft.com/user.read"]
        static let Authority = "https://login.microsoftonline.com/common"
    }
    
    
}
