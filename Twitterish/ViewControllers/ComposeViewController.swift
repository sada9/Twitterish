//
//  ComposeViewController.swift
//  Twitterish
//
//  Created by Pattanashetty, Sadananda on 4/15/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var ava: UIImageView!
    
    @IBOutlet weak var tweetTxtBox: UITextView!
    @IBOutlet weak var close: UIImageView!

    @IBOutlet weak var placeholderText: UILabel!

    var viewModel: ComposeViewModel?
    var counter: UIBarButtonItem?
    var tweetButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        ava.setImageWith((viewModel?.user.profileUrl)!)
        addToolBar(textField: tweetTxtBox)

        tweetTxtBox.becomeFirstResponder()
        tweetTxtBox.delegate = self

        ava.layer.cornerRadius = 5
        ava.clipsToBounds = true

        //reply button
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(closeView))
        self.close.addGestureRecognizer(gesture)


    }

    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.blackOpaque
        toolBar.isTranslucent = true
        toolBar.tintColor = hexStringToUIColor(hex: "#3498db")

         tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ComposeViewController.tweetPressed))


         counter = UIBarButtonItem(title: "140", style: UIBarButtonItemStyle.plain, target: self, action:nil)
         counter?.tintColor = UIColor.white

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, counter! ,tweetButton!], animated: false)

        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        //textField.delegate = self
        textField.inputAccessoryView = toolBar
    }

    func tweetPressed(){
        viewModel?.tweet(t: tweetTxtBox.text)
        closeView()
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

extension ComposeViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        var limit:Int
        if textView.text.isEmpty {
            placeholderText.isHidden = false
            disableButton()
            limit = 140
            counter?.title = "\(limit)"

        } else {
            placeholderText.isHidden = true
            limit = 140 - textView.text.characters.count
            if (limit < 20) && (limit >= 0){
                textRedColor()
                enableButton()
            } else if limit < 0 {
                textRedColor()
                disableButton()
            } else {
                textNormalColor()
                enableButton()
            }
            counter?.title = "\(limit)"
        }
    }

    func disableButton() {
        tweetButton?.isEnabled = false
        tweetButton?.tintColor = UIColor.lightGray
    }

    func enableButton() {

        tweetButton?.isEnabled = true
        tweetButton?.tintColor =  hexStringToUIColor(hex: "#3498db")
    }

    func textNormalColor() {
       counter?.tintColor = UIColor.white
    }

    func textRedColor() {
        counter?.tintColor = UIColor.red
    }

}
