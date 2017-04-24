//
//  AccountsViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/23/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //AddUserCell AccountCell

        if  User.users != nil && indexPath.row != User.users?.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.user = User.users?[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserCell", for: indexPath) 
            return cell

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let users = User.users else {
            return 1
        }
       return  users.count + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if  User.users?.count == indexPath.row {
            TwitterClient.sharedInstance?.delegate = self
            TwitterClient.sharedInstance?.login() { (result: Result) -> Void in
                print(result)
                //self.performSegue(withIdentifier: "MenuViewSegue", sender: nil)

                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let conViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController

                conViewController.menuViewController = menuViewController

                menuViewController.containerViewController = conViewController

                self.present(conViewController, animated: false, completion: nil)

            }
        } else {

            User._currentUser = User.users?[indexPath.row]

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let conViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController

            conViewController.menuViewController = menuViewController

            menuViewController.containerViewController = conViewController

            self.present(conViewController, animated: false, completion: nil)

        }

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TweetViewController") as! TweetViewController
//
//        let tweet = viewModel?.tweet(at: indexPath)
//        vc.viewModel = TweetViewModel(t: tweet!)
//        self.show(vc, sender: nil)
    }



}

class AccountCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var handleLbl: UILabel!
    var user:  User! {
        didSet {
            guard let user = user else {
                return
            }
            avatar.setImageWith(self.user.profileUrl!)
            userName.text = user.name
            handleLbl.text = user.screenName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension AccountsViewController: TwitterClientDelegate {

    func finishedFetchingData(result : Result) {

        switch result {
        case .Success(let result):
            print(result[0].text ?? "--")

        case .Failure(let errorStr):
            print(errorStr)

        default: print("unknow result")

        }
    }
    
    func newTweet(t: Tweet) {
        
    }
}


