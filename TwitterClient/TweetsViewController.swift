//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/15/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    var isMentionsView = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(self.loadTweets(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTweets()
    }
    
    func loadTweets(_ refreshControl: UIRefreshControl) {
        loadTweets()
    }
    
    func loadTweets() {
        
        if (isMentionsView) {
            TwitterClient.sharedInstance?.mentionsList(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
                
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
                
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onProfileImageTap))
        cell.profileImageView.addGestureRecognizer(tap)
        cell.profileImageView.isUserInteractionEnabled = true
        
        // Add tag to find row when clicking on a button inside cell
        cell.replyButton.tag = indexPath.row
        cell.profileImageView.tag = indexPath.row
        
        return cell
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyButton(_ sender: Any) {
        let sender = sender as AnyObject
        self.performSegue(withIdentifier: "postSegue", sender: sender)
    }
    
    func onProfileImageTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "profileSegue", sender: sender)
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
        
        if let sender = sender as? UITapGestureRecognizer {
            let tappedView = sender.view
            let tweet = tweets[(tappedView?.tag)!]
            
            if let profileNavigationController = segue.destination as? UINavigationController {
                
                let pvc = profileNavigationController.viewControllers[0] as! ProfileViewController
                pvc.screenName = tweet.username
            }
        }
        
        if let cell = sender as? TweetCell {
        
            let indexPath = tableView.indexPath(for: cell)
            
            let tweet = tweets[(indexPath?.row)!]
            
            if let tweetViewController = segue.destination as? TweetViewController {
                tweetViewController.tweet = tweet
            }
        }
    }
}
