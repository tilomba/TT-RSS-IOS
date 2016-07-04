//
//  ViewController.swift
//  TT-RSS-IOS
//
//  Created by tilomba
//  Copyright (c) 2016 tilomba. All rights reserved.
//


import UIKit
import Gloss
import KINWebBrowser

class HeadlinesViewController: UITableViewController {
    var items = [HeadlineTableItem]()
    var selectedFeedCells = [Int: HeadlineTableItem] ()
    
    internal var selectedFeed: FeedTableItem!
    internal var token = ""
    internal var TTRSSURL = ""

    
    override func viewDidLoad() {
        print("HeadlinesViewController showing")
    }
    
    override func viewWillAppear(animated: Bool)
    {        
         self.ttrssGetHeadlines("getHeadlines", feedId: selectedFeed.id!) { (headlineResult) in
             if(headlineResult != nil)
             {
                 for headline in (headlineResult?.content)! {
                     var headlineItem = HeadlineTableItem()
                     headlineItem!.identifer = "identifier"
                     headlineItem!.author = headline.author ?? ""
                     headlineItem!.date = NSDate()
                     headlineItem!.enclosures = []
                     headlineItem!.link = headline.link ?? ""
                     headlineItem!.summary = headline.note ?? ""
                     headlineItem!.title = headline.title ?? ""
                     headlineItem!.updated = NSDate()
                     headlineItem!.unread = headline.unread!
                     headlineItem!.articleId = headline.id ?? 0
                     self.items.append(headlineItem!)
                 
                 }
                 dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     self.tableView.reloadData()
                 })
             }
             else
             {
                 print ("getHeadlines failure")
             }
         }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "HeadlineCell")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let item = self.items[indexPath.row] as MWFeedItem
        let item = self.items[indexPath.row] as HeadlineTableItem
        let con = KINWebBrowserViewController()
        let URL = NSURL(string: item.link as String)
        con.loadURL(URL)
        self.navigationController?.pushViewController(con, animated: true)
        // Set item as read
        self.ttrssSetArticleAsRead("updateArticle", articleId: item.articleId) { (statusResult) in
            if(statusResult != nil &&
                statusResult?.content != nil &&
                statusResult?.content?.status == "OK")
            {
                print ("Status = success")
                
                // http://stackoverflow.com/questions/26083049/swift-update-cell-accessory-type
                
                let articleId = self.items[indexPath.row].articleId
                
                if (self.selectedFeedCells[articleId] != nil)
                {
                    self.selectedFeedCells.removeValueForKey(articleId)
                }
                else
                {
                    self.selectedFeedCells[articleId] = self.items[indexPath.row]
                }
                tableView.deselectRowAtIndexPath(indexPath, animated:false)
            }
            else
            {
                print ("Status = failure")
            }
        }
        
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let item = self.items[indexPath.row] as HeadlineTableItem
        cell.textLabel?.text = item.title as String
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.numberOfLines = 0
        if(item.unread == false || self.selectedFeedCells[item.articleId] != nil)
        {
            cell.backgroundColor = UIColor.grayColor()
        }
        
        
        let projectURL = item.link.componentsSeparatedByString("?")[0]
        let imgURL: NSURL? = NSURL(string: projectURL + "/cover_image?style=200x200#")
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.setImageWithURL(imgURL!, placeholderImage: UIImage(named: "logo.png"))
    }

    func ttrssGetHeadlines(opAPIMethod: NSString, feedId: Int,completionClosure: (results: TTRSSGetHeadlinesResponse?)-> ())-> NSString {
        
        // Setup the session to make REST POST call
        let url = NSURL(string: self.TTRSSURL)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["op": "\(opAPIMethod)" as NSString, "sid": "\(self.token)" as NSString, "feed_id": "\(feedId)" as NSString, "is_cat": "false", "show_excerpt": "true" ]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print("Post Params: \(postParams)")
        } catch {
            print("bad things happened")
            completionClosure(results: nil )
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    completionClosure(results: nil)
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                //                print("JSON (ttrssGetHeadlines): " + postString)
                do {
                    let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                    guard let getHeadlinesResponse = TTRSSGetHeadlinesResponse(json: json!)
                        else {
                            print("Error initializing object")
                            return
                    }
                    completionClosure(results: getHeadlinesResponse)
                } catch {
                    print(error)
                }
            }
            
        }).resume()
        
        return ""
    }
    
    func ttrssSetArticleAsRead(opAPIMethod: NSString, articleId: Int,completionClosure: (results: TTRSSStatusResponse?)-> ()) {
        
        // Setup the session to make REST POST call
        let url = NSURL(string: self.TTRSSURL)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["op": "\(opAPIMethod)" as NSString, "sid": "\(self.token)" as NSString, "article_ids": "\(articleId)" as NSString, "mode": "0", "field": "2" ]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print("Post Params: \(postParams)")
        } catch {
            print("bad things happened")
            completionClosure(results: nil )
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    completionClosure(results: nil )
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("JSON (ttrssSetArticleAsRead): " + postString)
                do {
                    let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                    guard let getStatusResponse = TTRSSStatusResponse(json: json!)
                        else {
                            print("Error initializing object")
                            completionClosure(results: nil )
                            return
                    }
                    completionClosure(results: getStatusResponse )
                } catch {
                    print(error)
                }
            }
            
        }).resume()
    }
}