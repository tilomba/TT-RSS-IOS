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

class FeedsViewController: UITableViewController, protocolSettingsModal {
    
    
    var items = [FeedTableItem]()
    var token = ""
    var TTRSSURL = ""
    var TTRSSUsername = ""
    var TTRSSPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.removeObjectForKey("TTRSSURL")
        if let defaultTTRSSUsername = defaults.stringForKey("TTRSSUsername")
        {
            self.TTRSSUsername = defaultTTRSSUsername
        }
        if let defaultTTRSSPassword = defaults.stringForKey("TTRSSPassword")
        {
            self.TTRSSPassword = defaultTTRSSPassword
        }
        if let defaultTTRSSURL = defaults.stringForKey("TTRSSURL")
        {
            self.TTRSSURL = defaultTTRSSURL
        }
        else
        {
            print("No URL set")
            ShowSettingsModal(defaults)
            return
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.TTRSSURL != "" && self.token == ""
        {
            ttrssLogin( {
                (session_token: NSString) in
                self.token = session_token as String
                self.request()
            })
        }
    }
    
    func buttonAction(sender: UIButton!) {
        self.items = [FeedTableItem]()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        ShowSettingsModal(NSUserDefaults.standardUserDefaults())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func ShowSettingsModal(defaults: NSUserDefaults)
    {
        self.performSegueWithIdentifier("SettingsSegue", sender: self)
    }
    
    func request()
    {
        
        ttrssGetFeeds("getFeeds") { (feedResult) in
            if(feedResult != nil)
            {
                print ("getFeeds successful")
                for feed in (feedResult?.content)! {
                    var item2 = FeedTableItem()
                    item2.title = feed.title
                    item2.cat_id = feed.cat_id
                    item2.id = feed.id
                    item2.unread = feed.unread
                    self.items.append(item2)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            else
            {
                print ("getFeeds failure")
            }
        }
        
 
    }
    
    func ttrssLogin(completionClosure: (session_token: NSString)-> ())-> NSString {
        
        // Setup the session to make REST POST call
        let url = NSURL(string: self.TTRSSURL)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["op": "login", "user": "\(self.TTRSSUsername)", "password": "\(self.TTRSSPassword)"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("JSON (ttrssLogin): " + postString)
                if postString.containsString("LOGIN_ERROR")
                {
                    let alert = UIAlertController(title: "Error", message: "Login failed.  Check username and password", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  { (UIActionAlert) -> Void in
                        self.performSegueWithIdentifier("SettingsSegue", sender: self)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
                else
                {
                    do {
                        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                        guard let loginResponse = TTRSSLoginResponse(json: json! as JSON) else {
                            print("Error initializing object")
                            return
                        }
                        completionClosure(session_token: loginResponse.session_id!)
                    } catch {
                        print(error)
                    }
                }
            }
            
        }).resume()
        
        return ""
    }

    func ttrssGetFeeds(opAPIMethod: NSString, completionClosure: (results: TTRSSGetFeedsResponse?)-> ())-> NSString {
        
        // Setup the session to make REST POST call
        let url = NSURL(string: self.TTRSSURL)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["op": "\(opAPIMethod)" as NSString, "sid": "\(self.token)" as NSString, "include_nested": "false" as NSString, "cat_id": "-4"]
        
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
                print("JSON (ttrssGetFeeds): " + postString)
                do {
                    let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                    guard let getFeedsResponse = TTRSSGetFeedsResponse(json: json!)
                    else {
                        print("Error initializing object")
                        return
                    }
                    completionClosure(results: getFeedsResponse)
                } catch {
                    print(error)
                }
            }
            
        }).resume()
        
        return ""
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
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FeedCell")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("HeadlineList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier=="HeadlineList")
        {
            let headlineViewController = segue.destinationViewController as! HeadlinesViewController
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            headlineViewController.selectedFeed = self.items[indexPath.row] as FeedTableItem
            headlineViewController.TTRSSURL = self.TTRSSURL
            headlineViewController.token = self.token
        }
        if(segue.identifier=="SettingsSegue")
        {
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.closeProtocol = self
        }
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as FeedTableItem
        cell.textLabel?.text = item.title! as String
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func closedSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultTTRSSURL = defaults.stringForKey("TTRSSURL")
        {
            self.TTRSSURL = defaultTTRSSURL
        }
        if let defaultTTRSSUsername = defaults.stringForKey("TTRSSUsername")
        {
            self.TTRSSUsername = defaultTTRSSUsername
        }
        if let defaultTTRSSPassword = defaults.stringForKey("TTRSSPassword")
        {
            self.TTRSSPassword = defaultTTRSSPassword
        }
        if self.TTRSSURL != "" && self.token == ""
        {
            ttrssLogin( {
                (session_token: NSString) in
                self.token = session_token as String
                self.request()
            })
        }
        else if self.TTRSSURL != ""
        {
            self.request()
        }
    }

}

