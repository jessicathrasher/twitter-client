//
//  Tweet.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/15/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit
import SwiftMoment

class Tweet: NSObject {

    var text: String?
    var timeSince: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var name: String?
    var username: String?
    var profileImageURL: URL?
    var tweetId: String?
    var retweetString: String?
    
    
    init(dictionary: [String: Any]) {
        
        text = dictionary["text"] as? String

        retweetCount = dictionary["retweet_count"] as? Int ?? 0

        favoritesCount = dictionary["favorite_count"] as? Int ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeSince = moment(formatter.date(from: timestampString)!).fromNow()
         
        }
        
        let userInfo = dictionary["user"] as! [String: Any]
        
        let imageURL = userInfo["profile_image_url_https"] as? String
        
        if let imageURL = imageURL {
            profileImageURL = URL(string: imageURL)
        }
        
        name = userInfo["name"] as? String
        
        username = "@\(userInfo["screen_name"] as? String ?? "")"
        
        tweetId = dictionary["id_str"] as? String
        
        if let retweeted = dictionary["retweeted_status"] as? [String: Any] {
        
            let name = retweeted["in_reply_to_screen_name"] as! String
            
            retweetString = name + " retweeted"
            
        }
    }
    
    class func tweetsWithArray(dictionaries: [[String: Any]]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
    
        return tweets
    }
    
}
