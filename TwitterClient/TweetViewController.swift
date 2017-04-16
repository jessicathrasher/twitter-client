//
//  TweetViewController.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/16/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweet: Tweet!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = tweet.name
        tweetLabel.text = tweet.text
        userName.text = tweet.username
        
        if let url = tweet.profileImageURL {
            profileImageView.setImageWith(url)
        }
        
        timestampLabel.text = tweet.timeSince
        
        numRetweetsLabel.text = tweet.retweetCount.description
        numFavoritesLabel.text = tweet.favoritesCount.description
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
