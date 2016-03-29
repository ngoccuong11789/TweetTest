//
//  TweetsViewController.swift
//  Twitter
//
//  Created by mac on 3/25/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
//import BDBOAuth1Manager

class TweetsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , TweetCellFavoriteDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]!
    var user : User!
    let myRequest = NSURLRequest()
    
    func favorite(statusTwitterViewCell: StatusTwitterViewCell) {
        print(123)
    }
    
    var detailContent: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.idTweet)
                print(tweet.favoriteStatus)
                //print(tweet.text!)
                //print(tweet.nameArray!)
//                print(tweet.username!)
//                if tweet.profileImageUrl != nil {
//                    print(tweet.profileImageUrl!)
//                }
//                if tweet.timestamp != nil {
//
//                    print(tweet.timestamp)
//                
//
//                }
//                    print(tweet.screenName)
                
            }
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            })
        
        TwitterClient.sharedInstance.currentAccount({(user: User) in
            self.user = user
            print("User name: \(user.name!)")
        }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
    }

    
    @IBAction func logoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        /*TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            //let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
            let request = NSURLRequest(
                URL: url,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            
            // Configure session so that completion handler is executed on main UI thread
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (data, response, error) in
                    //data
                    // ... Use the new data to update the data source ...
            
                    // Reload the tableView now that there is new data
                    self.tableView.reloadData()
                    
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
            });
            task.resume()
            
        }) {(error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
        }*/
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            //print(tweets.count)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            //print(tweets.count)
            refreshControl.endRefreshing()
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! StatusTwitterViewCell
        //let tweet : Tweet
        
        //tweet = tweets[indexPath.row]
        cell.favoriteDelegate = self
        cell.tweet = tweets[indexPath.row]
        /*cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
         UIView.animateWithDuration(0.25, animations: {
         cell.layer.transform = CATransform3DMakeScale(1,1,1)
         })
         */
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(1, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
        })
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewDetailTweet"{
            let selectedIndex = self.tableView.indexPathForCell(sender as! StatusTwitterViewCell)
        //let selectedCell = addressArray[(selectedIndex?.row)!]
        //let selectedCell = filteredData[(selectedIndex?.row)!].address!
            let selectedCell = tweets[(selectedIndex?.row)!]
            detailContent = selectedCell
            let twitterDetailViewController = segue.destinationViewController as! TwitterDetailViewController
            twitterDetailViewController.detailContent = self.detailContent
        }
    }
    

}


