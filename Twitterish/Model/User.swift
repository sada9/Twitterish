//
//  User.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/11/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class User {

    var name: String?
     var id: Int64 = 0
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    var location: String?
    var followersCount: Int = 0
    var followingCount: Int = 0

    var profileBGImgUrl: URL?
    var profileBGColor: String?



    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        id = (dictionary["id"] as? Int64)!
        name = dictionary["name"] as? String
        screenName = "@\((dictionary["screen_name"] as? String)!)"
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }

        if let profileBGUrlString = dictionary["profile_banner_url"] as? String {
            profileBGImgUrl = URL(string: profileBGUrlString + "/mobile_retina")
        }

        profileBGColor = dictionary["profile_background_color"] as? String

        tagline = dictionary["description"] as? String
        location = dictionary["location"] as? String
        followersCount = dictionary["followers_count"] as? Int ?? 0
        followingCount = dictionary["friends_count"] as? Int ?? 0

    }

    static private var _users: [User]? = [User]()

    class var users: [User]? {
        get {

            if _users?.count == 0 {
                let defaults = UserDefaults.standard

                let userData = defaults.object(forKey: "currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                    _users?.append(_currentUser!)
                }
            }

            return _users
        }
   }

    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard

                let userData = defaults.object(forKey: "currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }

        set(user) {
            _currentUser = user
            
            User._users?.append(user!)

            let defaults = UserDefaults.standard

            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
                defaults.set(data, forKey: "allAccounts")
            } else {
                defaults.set(nil, forKey: "currentUserData")
                defaults.set(nil, forKey: "allAccounts")
            }
            defaults.synchronize()
        }
    }
}
