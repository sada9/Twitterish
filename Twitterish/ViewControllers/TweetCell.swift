//
//  TweetCell.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/12/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate: class {

    func replyButtonTapped(tweetCell: TweetCell)
    func retweetButtonTapped(tweetCell: TweetCell)
    func likeButtonTapped(tweetCell: TweetCell)
    func avatarButtonTapped(tweetCell: TweetCell)

}

class TweetCell: UITableViewCell {

    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetBy: UILabel!
    @IBOutlet weak var tweetTypeImg: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var favCountLbl: UILabel!
    @IBOutlet weak var retweetCountLbl: UILabel!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var retweetImg: UIImageView!
  
    @IBOutlet weak var tweetTypeImgConstraint: UIImageView!

    @IBOutlet weak var tweetByHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tweetTypeImgHeightCons: NSLayoutConstraint!
    @IBOutlet weak var replyImg: UIImageView!

    weak var delegate: TweetCellDelegate!
    var indexPath: IndexPath!

    var tweet: Tweet! {
        didSet {
            userName.text = tweet.name
            handle.text = tweet.screenName
            tweetText.text = tweet.text
            date.text = tweet.timeStamp.characters.contains("s") ? " · Just now" : " · \(tweet.timeStamp)"
            retweetCountLbl.text = "\(tweet.retweetCount)"
            favCountLbl.text = "\(tweet.favoriteCount)"
            avatar.setImageWith((tweet.profileUrl)!)

            if tweet.isYourRetweet {
                retweetImg.image = #imageLiteral(resourceName: "Retweet-gree")
                retweetCountLbl.textColor = hexStringToUIColor(hex: "#1abc9c")
            }
            else {
                retweetImg.image = #imageLiteral(resourceName: "Retweet-64")
                retweetCountLbl.textColor = hexStringToUIColor(hex: "#666666")
            }

            if tweet.isYourFavorited {
                heartImg.image = #imageLiteral(resourceName: "Like Filled-50")
                favCountLbl.textColor = hexStringToUIColor(hex: "#e74c3c")
            }
            else {
                heartImg.image = #imageLiteral(resourceName: "Like-50")
                favCountLbl.textColor = hexStringToUIColor(hex: "#666666")
            }

            if !tweet.isTweet {
                tweetTypeImg.image = #imageLiteral(resourceName: "Retweet-64")
                tweetBy.text = (tweet.isYourRetweet ? "You" : tweet.retweetName!) + " Retweeted"
                tweetByHeightCons.constant = 12
                tweetTypeImgHeightCons.constant = 15
            }
            else {
                tweetByHeightCons.constant = 0
                tweetTypeImgHeightCons.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGesturesToImages()
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func addGesturesToImages() {
        //reply button
        var gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(replyTapped))
        self.replyImg.addGestureRecognizer(gesture)

        //rt button
        gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(retweetTapped))
        self.retweetImg.addGestureRecognizer(gesture)

        //like button
        gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(likeTapped))
        self.heartImg.addGestureRecognizer(gesture)

        //avatar button
        gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(avatarTapped))
        self.avatar.addGestureRecognizer(gesture)
    }


    func replyTapped() {
        delegate?.replyButtonTapped(tweetCell: self)
    }
    
    func retweetTapped() {
        delegate?.retweetButtonTapped(tweetCell: self)
    }

    func likeTapped() {
        delegate?.likeButtonTapped(tweetCell: self)
    }

    func avatarTapped() {
        delegate?.avatarButtonTapped(tweetCell: self)
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
