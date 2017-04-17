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
    @IBOutlet weak var retweetedByButton: UIButton!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = tweet.name
        tweetLabel.text = tweet.text
        userName.text = tweet.username
        
        if let url = tweet.profileImageURL {
            profileImageView.setImageWith(url)
        }
        
        if tweet.retweetString != nil {
            retweetedByLabel.text = tweet.retweetString
            retweetedByLabel.isHidden = false
            retweetedByButton.isHidden = false
        }
        
        if tweet.favorited! {
            likeButton.imageView?.image = UIImage(named: "like-action-on-1")
        }
        
        if tweet.retweeted! {
            retweetButton.imageView?.image = UIImage(named: "retweet-action-on")
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
    
    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(tweetId: tweet.tweetId!, success: { (tweet: Tweet) in
            print("retweeted")
            
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
    }
    
    @IBAction func onLikeButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(tweetId: tweet.tweetId!, success: { (tweet: Tweet) in
            print("favorited")
            
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // If we're going totest post from here, set this as the reply tweet
        let nc = segue.destination as! UINavigationController
        
        let vc = nc.viewControllers[0] as! PostViewController
        vc.replyTweetId = tweet.tweetId
    }
}
