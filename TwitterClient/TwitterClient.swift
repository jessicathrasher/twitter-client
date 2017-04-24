//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Jessica Thrasher on 4/15/17.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "2okAvhOuhU8iVs312xoNSQsXS", consumerSecret: "ej2mp8iyVHDU83AAuj73GX4DrDon2WEDjMR5qUXlIfxPzk5HKm")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize() // clear previous sessions
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: URL(string: "twittercp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)"
            let url = URL(string: urlString)!
            UIApplication.shared.open(url)
            
        }) { (error: Error!) -> Void in
            print("error \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.UserDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in

            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }) { (failure: Error!) -> Void in
            print("error: \(failure.localizedDescription)")
            self.loginFailure?(failure)
        }
    }

    func usersList(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/user_timeline.json?screen_name=\(screenName)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("user tweets: \(response.debugDescription)")
            
            let dictionary = response as! [[String: Any]]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            
            failure(error!)
        })
    }
    
    func mentionsList(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("mentions: \(response.debugDescription)")
            
            let dictionary = response as! [[String: Any]]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            
            failure(error!)
        })
        
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("timeline: \(response.debugDescription)")
            
            let dictionary = response as! [[String: Any]]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            
            failure(error!)
        })
        
    }
    
    func getUserProfile(screenname: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/users/show.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("account: \(response.debugDescription)")
            
            let userDictionary = response as! [String: Any]
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            failure(error!)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("account: \(response.debugDescription)")
            
            let userDictionary = response as! [String: Any]
            let user = User(dictionary: userDictionary)

            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            failure(error!)
        })
        
    }
    
    func retweet(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            print("retweet: \(response.debugDescription)")
            
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            failure(error!)
        })
        
    }
    
    func favorite(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            print("favorite: \(response.debugDescription)")
            
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            failure(error!)
        })
        
    }
    
    func post(status: String, replyId: String?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        let encodedStatus = status.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        var url = "1.1/statuses/update.json?status=\(encodedStatus!)"
        
        if let replyId = replyId {
            url = url + "&in_reply_to_status_id=\(replyId)"
        }
        
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("tweet: \(response.debugDescription)")

            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            failure(error!)
        })
    }
}
