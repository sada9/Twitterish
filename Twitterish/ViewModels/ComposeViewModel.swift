//
//  ComposeViewModel.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/15/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

class ComposeViewModel {

    var user: User
    init(user: User) {
        self.user = user
    }

    func tweet(t: String) {
        TwitterClient.sharedInstance?.tweet(tweetContent: t)
        
    }
}
