//
//  TweetViewModel.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/15/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

class TweetViewModel {

    var tweet: Tweet

    init(t: Tweet) {
        tweet = t
    }

    func rtLabel() -> String {
        return tweet.retweetCount == 1 ? "RETWEET" : "RETWEETS"
    }

    func likeLabel() -> String {
        return tweet.favoriteCount == 1 ? "LIKE" : "LIKES"
    }

    func retweet() {
        if tweet.isYourRetweet {
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetId, value: false)
            tweet.retweetCount -= 1
        }
        else {
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetId, value: true)
            tweet.retweetCount += 1
        }

        tweet.isYourRetweet = !tweet.isYourRetweet
    }

    func like() {
        if tweet.isYourFavorited {
            TwitterClient.sharedInstance?.like(id: tweet.tweetId, value: false)
            tweet.favoriteCount -= 1
        }
        else {
            TwitterClient.sharedInstance?.like(id: tweet.tweetId, value: true)
            tweet.favoriteCount += 1
        }

        tweet.isYourFavorited = !tweet.isYourFavorited
    }

}
