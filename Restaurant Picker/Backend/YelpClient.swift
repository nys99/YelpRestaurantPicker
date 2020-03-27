//
//  YelpServic.swift
//  Restaurant Picker
//
//  Created by Nikhil Sharma on 3/17/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import Foundation
import CDYelpFusionKit
import CoreLocation

final class YelpClient: NSObject {
    // Fill in your app keys here from
    // https://www.yelp.com/developers/v3/manage_app
    
    static let shared = YelpClient()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {
        // How to authorize using your clientId and clientSecret
        // set your app key as an environment (https://nshipster.com/launch-arguments-and-environment-variables/) variable in xcode
        let app_key = ProcessInfo.processInfo.environment["REST_PICKER_APP_KEY"]
        self.apiClient = CDYelpAPIClient(apiKey: app_key!)
    }
    
}
