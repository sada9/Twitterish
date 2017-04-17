//
//  ReplyViewModel.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/15/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

class ReplyViewModel {

    var tweet: Tweet

    init(t: Tweet) {
        self.tweet = t
    }

    func reply(t: String) {
        TwitterClient.sharedInstance?.reply(replyTweet: t, statusID: tweet , params: nil, completion: { (error:Error?) in
            print("Replied!")
        })
    }

    
}
