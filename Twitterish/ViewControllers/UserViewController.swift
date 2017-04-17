//
//  UserViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/16/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {


    var user: User?
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followers: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user?.name
        handle.text = user?.screenName
        tagline.text = user?.tagline
        avatar.setImageWith((user?.profileUrl)!)

        if let img = user?.profileBGImgUrl {
            bgImage.setImageWith(img)
        }

        address.text = user?.location
        followers.text = "\((user?.followersCount)!)"
        followingCount.text = "\((user?.followingCount)!)"
    }

    //typo here - :D
    @IBAction func singoutTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

   
}
