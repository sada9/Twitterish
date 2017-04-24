//
//  MenuViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/21/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import AFNetworking

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTable: UITableView!

    var containerViewController: ContainerViewController!
    

    private let menuItem = ["","Timeline", "Mention", "Accounts", "Add User", "Sing out"]
    private let icons = ["","timeline","chat","people","add_user", "Exit-64"]

    private var meViewController: UIViewController!
    private var timeLineViewController: UIViewController!
    private var mentionViewController: UIViewController!
     private var accountsViewController: UIViewController!

    private var suggestionViewController: UIViewController!
     var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.rowHeight = UITableViewAutomaticDimension
        menuTable.estimatedRowHeight = 150

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        meViewController = storyBoard.instantiateViewController(withIdentifier: "MeViewController") as! MeViewController

        timeLineViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        mentionViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        accountsViewController = storyBoard.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
        suggestionViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        viewControllers.append(meViewController)
        viewControllers.append(timeLineViewController)
        viewControllers.append(mentionViewController)
        viewControllers.append(accountsViewController)
        viewControllers.append(suggestionViewController)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
             cell.user = User.currentUser
            return cell
        }
        else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            cell.menuItem.text = menuItem[indexPath.row]
            cell.menuItemImage.image = UIImage(named: icons[indexPath.row])
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.row == 0 {
//            tableView.deselectRow(at: indexPath, animated: true)
//            containerViewController.contentViewController = meViewController
//            return
//        }

        tableView.deselectRow(at: indexPath, animated: true)
         containerViewController.contentViewController = viewControllers[indexPath.row]

    }



}


class MenuItemCell: UITableViewCell {

    @IBOutlet weak var menuItemImage: UIImageView!
    @IBOutlet weak var menuItem: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class ProfileCell: UITableViewCell {

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
