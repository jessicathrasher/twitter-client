//
//  PostViewController.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/16/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextField: UITextField!
    
    var replyTweetId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.currentUser!
        
        nameLabel.text = user.name
        usernameLabel.text = user.screenname
        
        if let profileUrl = user.profileUrl {
            profileImageView.setImageWith(profileUrl)
        }
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        
        tweetTextField.becomeFirstResponder()
        
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
        
        if let status = tweetTextField.text {
            TwitterClient.sharedInstance?.post(status: status, replyId: replyTweetId, success: { (tweet: Tweet) in
                print("posted")
            }, failure: { (error: Error) in
                print("error: \(error)")
            })
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
