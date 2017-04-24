//
//  ContainerViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/20/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!

    @IBOutlet weak var containerViewLeadingPadContraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!

    var menuViewController: MenuViewController! {

        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }


    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()

            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }

            contentViewController.willMove(toParentViewController: self)
            containerView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)

            UIView.animate(withDuration: 0.3) { () -> Void in
                self.containerViewLeadingPadContraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    enum Direction {
        case up, down, right, left
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if (TwitterClient.sharedInstance?.isAuthorized)! {
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            containerView.addSubview(homeViewController.view)
       }
        else {
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
            containerView.addSubview(homeViewController.view)
        }



    }

    @IBAction func onContainerPanGesture(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == .began {
            originalLeftMargin = containerViewLeadingPadContraint.constant
        } else if sender.state == .changed {
            containerViewLeadingPadContraint.constant = originalLeftMargin + translation.x
        }
        else if sender.state == .ended {

            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 { // open menu view
                self.containerViewLeadingPadContraint.constant = self.view.frame.size.width - 50
            } else { // close menu view
                self.containerViewLeadingPadContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }



}
}
