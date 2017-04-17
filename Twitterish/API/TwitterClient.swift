//
//  TwitterClient.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/11/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import FTIndicator

protocol TwitterClientDelegate: class {
    func finishedFetchingData(result : Result)
    func newTweet(t: Tweet)
}

enum Result {
    case Authenticated(User)
    case Success([Tweet])
    case Failure(String)
}

let twitterConsumerKey = "mDGXW3ZzAbXVYgOXLMnmmdoRo"
let twitterConsumerSecret = "YExlTRVufwg4hKSaHej2tkwSJ5wq4DORCRWx5MDb9I2H5Ee8EX"
let twitterToken = ""
let twitterTokenSecret = ""
let twitterBaseURL  = "https://api.twitter.com"

class TwitterClient: BDBOAuth1SessionManager {

    static var sharedInstance = TwitterClient(baseURL: URL(string: twitterBaseURL), consumerKey:twitterConsumerKey, consumerSecret: twitterConsumerSecret)

    var resultCallBack: ((Result) -> Void)?
    weak var delegate: TwitterClientDelegate?

    var currentUser: User?


    func login(result: @escaping (Result)-> Void) {
        self.resultCallBack = result

        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "twitterish://oauth"),
            scope: nil,
            success: { (requestToken) in
                if let urlString = requestToken?.token {
                    let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(urlString)")!
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        }, failure: { (error) in
            print("\(error?.localizedDescription)")
            self.resultCallBack!(Result.Failure((error?.localizedDescription)!))
        })
    }

    func logout() {
        TwitterClient.sharedInstance?.deauthorize()
    }

    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in

            self.verifyCredentials(success: { (user) in
                User.currentUser = user
                self.resultCallBack!(Result.Authenticated(user))
            }, failure: { (error) in
                self.resultCallBack!(Result.Failure((error.localizedDescription)))
            })
        }) { (error) in
            print("\(error?.localizedDescription)")
            self.resultCallBack!(Result.Failure((error?.localizedDescription)!))
        }
    }


   private func verifyCredentials(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            self.currentUser = user
            success(user)
        }) { (task, error) in
            print("\(error.localizedDescription)")
            failure(error)
        }
    }

    func homeTimeline() {

        let parameters: [String : AnyObject] = ["trim_user": "false" as AnyObject, "count": "50" as AnyObject]

        get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
               self.delegate?.finishedFetchingData(result: Result.Success(tweets))
        }) { (task, error) in
            print("\(error.localizedDescription)")
           self.delegate?.finishedFetchingData(result: Result.Failure(error.localizedDescription))
        }
    }

    func getTweetById(id: String) {

        let url = "1.1/statuses/show.json?id=\(id)"
        get(url, parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            self.delegate?.finishedFetchingData(result: Result.Success(tweets))
        }) { (task, error) in
            print("\(error.localizedDescription)")
            self.delegate?.finishedFetchingData(result: Result.Failure(error.localizedDescription))
        }
    }

    func userTimeline(parameters: Any?) {
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            print(dictionaries)
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            self.delegate?.finishedFetchingData(result: Result.Success(tweets))
        }) { (task, error) in
            print("\(error.localizedDescription)")
            self.delegate?.finishedFetchingData(result: Result.Failure(error.localizedDescription))
        }
    }

    func tweet(tweetContent: String) {
        let parameters: [String: String] = ["status": tweetContent]
        post("1.1/statuses/update.json", parameters: parameters, progress: nil,
             success: { (task, response) in
                        print("Success T")
                        FTIndicator.showNotification(withTitle: "Success", message: "Tweeted Successfully!")
                        let nt = Tweet(dictionary: response as! NSDictionary)
                        self.delegate?.newTweet(t: nt)

                } ) { (task, error) in
            print("\(error.localizedDescription)")
        }
    }

    func retweet(id: Int, value: Bool) {
        let parameters: [String: Int] = ["id": id]

        if value {
            post("1.1/statuses/retweet.json", parameters: parameters, progress: nil,
                 success: { (task, response) in print("Success RT") } ) { (task, error) in
                print("\(error.localizedDescription)")
            }
        } else {
            post("1.1/statuses/unretweet.json", parameters: parameters, progress: nil, success: { (task, response) in print("Success UnRT") }) { (task, error) in
                print("\(error.localizedDescription)")
            }
        }
    }

    func like(id: Int, value: Bool) {
        let parameters: [String: Int] = ["id": id]

        if value {
            post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task, response) in print("Success Like") }) { (task, error) in
                print("\(error.localizedDescription)")
            }
        } else {
            post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task, response) in print("Success unlike") }) { (task, error) in
                print("\(error.localizedDescription)")
            }
        }
    }

    func reply(replyTweet: String, statusID: Tweet, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        var params : [String : Any] = ["status": replyTweet]

        params["in_reply_to_screen_name"] = statusID.user?.screenName
        params["in_reply_to_status_id"] = statusID.tweetId
        params["in_reply_to_user_id"] = statusID.user?.id
        
        post("1.1/statuses/update.json",
            parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("tweeted: \(replyTweet)")
            FTIndicator.showNotification(withTitle: "Success", message: "Replied Successfully!")
            let nt = Tweet(dictionary: response as! NSDictionary)
            self.delegate?.newTweet(t: nt)

            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't reply")
            completion(error as NSError?)
        }
        )
    }
}
