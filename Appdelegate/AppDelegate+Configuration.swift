//
//  AppDelegate+Configuration.swift
//  OnDemandApp
//
//  Created by Arvind Singh on 14/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import TwitterKit
import Crashlytics
import Fabric

extension AppDelegate {
    // MARK: - Configure Crashlytics
    class func configureTwitter() {
        Twitter.sharedInstance().start(withConsumerKey: Constants.Tokens.twitterConsumerKey, consumerSecret: Constants.Tokens.twitterSecretKey)
        Fabric.with([Twitter.self, Crashlytics.self])
    }
}
