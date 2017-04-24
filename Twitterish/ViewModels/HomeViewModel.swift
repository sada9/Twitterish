//
//  HomeViewModel.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/12/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate : class {
    func dataReady()
    func error(err: String)
}

class HomeViewModel {

     var delegate: HomeViewModelDelegate?
     var tweets: [Tweet]?

   
    func fetch() {
        TwitterClient.sharedInstance?.delegate = self
        TwitterClient.sharedInstance?.homeTimeline()
    }

    func fetchMyTweets(user: User) {
        TwitterClient.sharedInstance?.delegate = self
        TwitterClient.sharedInstance?.userTimeline(user: user)
    }

    func tweet(at indexPath: IndexPath) -> Tweet? {
        return tweets?[indexPath.row]
    }

    func refresh(){
        print("refresh - fetching new tweets..")
         TwitterClient.sharedInstance?.delegate = self
        TwitterClient.sharedInstance?.homeTimeline()
    }

    func currentUser() -> User {
        return (User.currentUser)!
    }

    func retweet(indexPath: IndexPath) {

        if (tweets?[indexPath.row].isYourRetweet)! {
            TwitterClient.sharedInstance?.retweet(id: (tweets?[indexPath.row].tweetId)!, value: false)
            tweets?[indexPath.row].retweetCount -= 1
        }
        else {
            TwitterClient.sharedInstance?.retweet(id: (tweets?[indexPath.row].tweetId)!, value: true)
            tweets?[indexPath.row].retweetCount += 1
        }

        tweets?[indexPath.row].isYourRetweet = !(tweets?[indexPath.row].isYourRetweet)!
    }

    func like(indexPath: IndexPath) {
        if (tweets?[indexPath.row].isYourFavorited)! {
            TwitterClient.sharedInstance?.like(id: (tweets?[indexPath.row].tweetId)!, value: false)
            tweets?[indexPath.row].favoriteCount -= 1
        }
        else {
            TwitterClient.sharedInstance?.like(id: (tweets?[indexPath.row].tweetId)!, value: true)
            tweets?[indexPath.row].favoriteCount += 1
        }

        tweets?[indexPath.row].isYourFavorited = !(tweets?[indexPath.row].isYourFavorited)!
    }

}


extension HomeViewModel: TwitterClientDelegate {

    func finishedFetchingData(result : Result) {

        switch result {
            
        case .Success(let result):
            tweets = result
            delegate?.dataReady()

        case .Failure(let errorStr):
            print(errorStr)
            delegate?.error(err: errorStr)

        default: print("unknow result")
            
        }
    }

    func newTweet(t : Tweet) {
        var moreTweets = self.tweets
        moreTweets?.insert(t, at: 0)
        tweets = moreTweets
        delegate?.dataReady()
    }
}
