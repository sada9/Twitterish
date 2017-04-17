//
//  TweetViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/13/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var rtCount: UILabel!
    @IBOutlet weak var rtLbl: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var replyImg: UIImageView!
    @IBOutlet weak var retweetImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tweetBy: UILabel!

    @IBOutlet weak var backButton: UIImageView!

    @IBOutlet weak var tweetTypeImg: UIImageView!
    @IBOutlet weak var nameTopContraint: NSLayoutConstraint!
    
    var viewModel: TweetViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesturesToImages()
        self.load()
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true
    }

    @IBOutlet weak var tweetTypeImgHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tweetByHeightCons: NSLayoutConstraint!

    func load() {
        name.text = viewModel?.tweet.name
        handle.text = viewModel?.tweet.screenName
        tweetText.text = viewModel?.tweet.text
        dateLbl.text = viewModel?.tweet.fullTimestamp()
        rtCount.text = "\((viewModel?.tweet.retweetCount)!)"
        rtLbl.text = viewModel?.rtLabel()

        likeCount.text = "\((viewModel?.tweet.favoriteCount)!)"
        likeLbl.text = viewModel?.likeLabel()

        avatar.setImageWith((viewModel?.tweet.profileUrl)!)

        retweetImg.image = (viewModel?.tweet.isYourRetweet)! ? #imageLiteral(resourceName: "Retweet-gree") : #imageLiteral(resourceName: "Retweet-64")
        likeImg.image = (viewModel?.tweet.isYourFavorited)! ? #imageLiteral(resourceName: "Like Filled-50") : #imageLiteral(resourceName: "Like-50")

        if !(viewModel?.tweet.isTweet)! {
            tweetTypeImg.image = #imageLiteral(resourceName: "Retweet-64")
            tweetBy.text = ((viewModel?.tweet.isYourRetweet)! ? "You" : (viewModel?.tweet.retweetName!)!) + " Retweeted"
            tweetByHeightCons.constant = 17
            tweetTypeImgHeightCons.constant = 18
        }
        else {
            tweetByHeightCons.constant = 0
            tweetTypeImgHeightCons.constant = 0
        }

    }

    func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    func replyTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController

        let tweet = viewModel?.tweet
        vc.viewModel = ReplyViewModel(t: tweet!)
        self.show(vc, sender: nil)

    }
    func retweetTapped() {
        viewModel?.retweet()
        self.load()
    }

    func likeTapped() {
        viewModel?.like()
        self.load()
    }

    func addGesturesToImages() {
        //back button
        var gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(TweetViewController.backTapped))
        backButton.addGestureRecognizer(gesture)

        //reply button
        gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(TweetViewController.replyTapped))
        self.replyImg.addGestureRecognizer(gesture)

        //rt button
         gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(TweetViewController.retweetTapped))
        self.retweetImg.addGestureRecognizer(gesture)

        //like button
         gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(TweetViewController.likeTapped))
        self.likeImg.addGestureRecognizer(gesture)
 }

}
