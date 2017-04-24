//
//  UserViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/16/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate { 

//
//    var user: User?
//    @IBOutlet weak var bgImage: UIImageView!
//    @IBOutlet weak var name: UILabel!
//
//    @IBOutlet weak var tagline: UILabel!
//    @IBOutlet weak var handle: UILabel!
//    @IBOutlet weak var avatar: UIImageView!
//
//    @IBOutlet weak var address: UILabel!
//    @IBOutlet weak var followingCount: UILabel!
//    @IBOutlet weak var followers: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        name.text = user?.name
//        handle.text = user?.screenName
//        tagline.text = user?.tagline
//        avatar.setImageWith((user?.profileUrl)!)
//        avatar.layer.cornerRadius = 5.0
//        avatar.layer.borderWidth = 4.0
//        avatar.layer.borderColor = UIColor.white.cgColor
//        avatar.clipsToBounds = true
//
//
//        if let img = user?.profileBGImgUrl {
//            bgImage.setImageWith(img)
//        }
//
//        address.text = user?.location
//        followers.text = "\((user?.followersCount)!)"
//        followingCount.text = "\((user?.followingCount)!)"
//    }

    var user: User?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var tweetsCount: UILabel!

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followers: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!

    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
       // user = User.currentUser

        name.text = user?.name
        handle.text = user?.screenName
        tagline.text = user?.tagline
        avatar.setImageWith((user?.profileUrl)!)
        avatar.layer.cornerRadius = 5.0
        avatar.layer.borderWidth = 4.0
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        tweetsCount.text = "1300"


        if let img = user?.profileBGImgUrl {
            bgImage.setImageWith(img)
        }

        address.text = user?.location
        followers.text = unitRep((user?.followersCount)!)
        followingCount.text = unitRep((user?.followingCount)!)
        scrollView.delegate = self

        viewModel = HomeViewModel()
        viewModel?.delegate = self
        viewModel?.fetchMyTweets(user: user!)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    func unitRep(_ count: Int) -> String {

        if count > 10000 {
            let temp = count/1000
            return "\(temp)K"
        }
        else {
            return "\(count)"
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = self.scrollView.contentOffset.y * 0.2
        let availableOffset = min(yOffset, 60)
        let contentRectYOffset = availableOffset / bgImage.frame.size.height
        bgImage.layer.contentsRect = CGRect(x: 0.0, y: contentRectYOffset, width: 1, height: 1);
    }

    //typo here - :D
    @IBAction func singoutTapped(_ sender: UIButton) {
        TwitterClient.sharedInstance?.logout()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

        cell.tweet = viewModel?.tweet(at: indexPath)!
        //cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tweets = self.viewModel?.tweets else {
            return 0
        }
        return (tweets.count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TweetViewController") as! TweetViewController

        let tweet = viewModel?.tweet(at: indexPath)
        vc.viewModel = TweetViewModel(t: tweet!)
        self.show(vc, sender: nil)
    }

   
    @IBAction func singoutTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


 extension UserViewController : HomeViewModelDelegate {

        func dataReady() {
            print("dataReady")
            print(viewModel?.tweets ?? "")

            tableView.reloadData()

        }

        func error(err: String) {
            print(err)
        }
}
