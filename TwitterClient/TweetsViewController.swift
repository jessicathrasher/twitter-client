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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadTweets(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.estimatedRowHeight = 250
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
    }
    
    func loadTweets(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) -> () in
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
        
        return cell
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.logout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? TweetCell {
        
            let indexPath = tableView.indexPath(for: cell)
            
            let tweet = tweets[(indexPath?.row)!]
            
            let tweetViewController = segue.destination as! TweetViewController
            tweetViewController.tweet = tweet
        }
        
    }
}
