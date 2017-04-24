//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/22/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User!
    var tweets: [Tweet]!
    var screenName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if screenName == nil {
            user = User.currentUser!
            setUpUser()
        } else {
            TwitterClient.sharedInstance?.getUserProfile(screenname: screenName, success: { (user: User) in
                self.user = user
                self.screenName = user.screenname
                self.setUpUser()
            }, failure: { (error: Error) in
                print("error \(error.localizedDescription)")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func setUpUser() {
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenname ?? "")"
        
        if let profileUrl = user.profileUrl {
            profileImageView.setImageWith(profileUrl)
        }
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        
        statusCountLabel.text = user.statusesCount?.description
        followersCountLabel.text = user.followersCount?.description
        followingCountLabel.text = user.followingCount?.description
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = 152
        
        loadTweets()
    }

    func loadTweets() {
        TwitterClient.sharedInstance?.usersList(screenName: user.screenname!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweets[indexPath.row]
        
        cell.tweetLabel.text = tweet.text
        cell.nameLabel.text = tweet.name
        cell.userNameLabel.text = tweet.username
        
        if let url = tweet.profileImageURL {
            cell.profileImageView.setImageWith(url)
        }
        
        cell.timeLabel.text = tweet.timeSince
        
        cell.tweetId = tweet.tweetId
        
        if let retweetedString = tweet.retweetString {
            cell.retweetedByLabel.text = retweetedString
            cell.retweetedByLabel.isHidden = false
            cell.retweetedButton.isHidden = false
        } else {
            cell.retweetedByLabel.isHidden = true
            cell.retweetedButton.isHidden = true
        }
        
        // Add tag to find row when clicking on a button inside cell
        cell.replyButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Reply button is sending us to Post
        // If we're going totest post from here, set this as the reply tweet
        if let sender = sender as? UIButton {
            if let nc = segue.destination as? UINavigationController {
                let tweet = tweets[sender.tag]
                
                let vc = nc.viewControllers[0] as? PostViewController
                vc?.replyTweetId = tweet.tweetId
            }
        }
        
        if let cell = sender as? TweetCell {
            
            let indexPath = tweetsTableView.indexPath(for: cell)
            
            let tweet = tweets[(indexPath?.row)!]
            
            if let tweetViewController = segue.destination as? TweetViewController {
                tweetViewController.tweet = tweet
            }
        }
    }
}
