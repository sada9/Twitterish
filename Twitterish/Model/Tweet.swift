//
//  Tweet.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/11/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class Tweet {
    var text: String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var profileUrl: URL?
    var name: String?
    var screenName: String?

    var retweetName: String?
    var createAt: NSDate?

    var timeStamp: String {
        return createAt?.timeAgoSimple() ?? ""
        //return ""
    }
    var fullTimeStamp: String {
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy HH:mm a"
        return formater.string(from: createAt as! Date)
    }
    var isTweet: Bool = true
    var tweetId: Int = 0
    var isYourFavorited: Bool = false
    var isYourRetweet: Bool = false
    var user: User?


    init(dictionary: NSDictionary){

        tweetId = (dictionary["id"] as? Int) ?? 0
        //check it is retweeted by you
        isYourRetweet = (dictionary["retweeted"] as? Bool) ?? false
        //check is is favorite by you
        isYourFavorited = (dictionary["favorited"] as? Bool) ?? false

        user = User(dictionary: dictionary["user"] as! NSDictionary)

        let retweetedStatus = dictionary.value(forKeyPath: "retweeted_status") as? NSDictionary
        if retweetedStatus != nil {
            //this is retweet
            isTweet = false

            //text
            text = dictionary.value(forKeyPath: "retweeted_status.text") as? String
            //retweetCount
            retweetCount = (dictionary.value(forKeyPath: "retweeted_status.retweet_count") as? Int) ?? 0
            //favoriteCount
            favoriteCount = (dictionary.value(forKeyPath: "retweeted_status.favorite_count") as? Int) ?? 0
            //name
            name = (dictionary.value(forKeyPath: "retweeted_status.user.name") as? String)!
            //screen name
            screenName = "@" + (dictionary.value(forKeyPath: "retweeted_status.user.screen_name") as? String)!
            //profile url
            let profileUrlString = dictionary.value(forKeyPath: "retweeted_status.user.profile_image_url_https") as? String
            if let url = profileUrlString {
                profileUrl = URL(string: url)
            }

            //retweet name
            retweetName = dictionary.value(forKeyPath: "user.name") as? String

        } else {
            //this is tweet
            //text
            text = dictionary.value(forKeyPath: "text") as? String
            //retweetCount
            retweetCount = (dictionary.value(forKeyPath: "retweet_count") as? Int) ?? 0
            //favoriteCount
            favoriteCount = (dictionary.value(forKeyPath: "favorite_count") as? Int) ?? 0
            //name
            name = dictionary.value(forKeyPath: "user.name") as? String
            //screen name
            screenName = "@" + (dictionary.value(forKeyPath: "user.screen_name") as? String)!
            //profile url
            let profileUrlString = dictionary.value(forKeyPath: "user.profile_image_url_https") as? String
            if let url = profileUrlString {
                profileUrl = URL(string: url)
            }

        }

        //timeStamp
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formater = DateFormatter()
            formater.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createAt = formater.date(from: timeStampString) as NSDate?

        }
    }


    func abbreviatedTimestamp() -> String {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.maximumUnitCount = 1
        dateComponentFormatter.unitsStyle = .abbreviated
        return dateComponentFormatter.string(from: abs((createAt?.timeIntervalSinceNow)!))!
    }

    func fullTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: createAt! as Date)

    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
