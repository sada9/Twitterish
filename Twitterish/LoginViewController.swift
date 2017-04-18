//
//  ViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/11/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {

        if (TwitterClient.sharedInstance?.isAuthorized)! {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        TwitterClient.sharedInstance?.login() { (result: Result) -> Void in
            print(result)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
}

extension LoginViewController: TwitterClientDelegate {

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

