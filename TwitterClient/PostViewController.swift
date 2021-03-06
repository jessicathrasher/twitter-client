//
//  PostViewController.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/16/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var replyTweetId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        
        let user = User.currentUser!
        
        nameLabel.text = user.name
        usernameLabel.text = user.screenname
        
        if let profileUrl = user.profileUrl {
            profileImageView.setImageWith(profileUrl)
        }
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        
        tweetTextView.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTweetButton(_ sender: Any) {
        
        if let status = tweetTextView.text {
            TwitterClient.sharedInstance?.post(status: status, replyId: replyTweetId, success: { (tweet: Tweet) in
                print("posted")
            }, failure: { (error: Error) in
                print("error: \(error)")
            })
            
            dismiss(animated: true, completion: nil)
        }
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        

//        
//    }
}
