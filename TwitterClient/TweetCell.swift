//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/15/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var retweetedButton: UIButton!
    
    var tweetId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        retweetedButton.isEnabled = false
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(tweetId: tweetId, success: { (tweet: Tweet) in
            print("retweeted")
            
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
    }
    
    @IBAction func onLikeButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(tweetId: tweetId, success: { (tweet: Tweet) in
            print("favorited")
            
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
    }
    
}
