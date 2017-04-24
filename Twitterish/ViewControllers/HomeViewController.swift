//
//  HomeViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/12/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import FTIndicator

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var isMoreDataLoading = false
    var viewModel: HomeViewModel?
    @IBOutlet weak var composeTweet: UIImageView!
    fileprivate let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        FTIndicator.setIndicatorStyle(.dark)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(composeTweetTapped))
        composeTweet.addGestureRecognizer(gesture)

        viewModel = HomeViewModel()
        viewModel?.delegate = self
        viewModel?.fetch()
        FTIndicator.showProgressWithmessage("Loading timeline..")
    }

    override func viewWillAppear(_ animated: Bool) {
        //viewModel = HomeViewModel()
        //viewModel?.delegate = self
        //FTIndicator.showProgressWithmessage("Loading timeline..")
    }

    func composeTweetTapped() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController

        vc.viewModel = ComposeViewModel(user: (viewModel?.currentUser())!)
        self.show(vc, sender: nil)
    }
    

    @objc private func refreshData(sender: UIRefreshControl ) {
        viewModel?.refresh()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

        cell.tweet = viewModel?.tweet(at: indexPath)!
        cell.delegate = self
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

}

extension HomeViewController : TweetCellDelegate {

    func replyButtonTapped(tweetCell: TweetCell) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController

        vc.viewModel = ReplyViewModel(t: (viewModel?.tweet(at: tweetCell.indexPath ))!)
     
        self.show(vc, sender: nil)
    }

    func retweetButtonTapped(tweetCell: TweetCell) {
        viewModel?.retweet(indexPath: tweetCell.indexPath)
        tweetCell.tweet = viewModel?.tweet(at: tweetCell.indexPath)
    }

    func likeButtonTapped(tweetCell: TweetCell) {
        viewModel?.like(indexPath: tweetCell.indexPath)
        tweetCell.tweet = viewModel?.tweet(at: tweetCell.indexPath)
    }

    func avatarButtonTapped(tweetCell: TweetCell) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController

        vc.user = viewModel?.tweet(at: tweetCell.indexPath)?.user

        self.show(vc, sender: nil)
    }
    
}

extension HomeViewController : HomeViewModelDelegate {

    func dataReady() {
        print("dataReady")
        print(viewModel?.tweets ?? "")
        FTIndicator.dismissProgress()
        tableView.reloadData()
        isMoreDataLoading = false
        refreshControl.endRefreshing()
    }

    func error(err: String) {
        print(err)
        FTIndicator.dismissProgress()
        isMoreDataLoading = false
        refreshControl.endRefreshing()
    }
}
