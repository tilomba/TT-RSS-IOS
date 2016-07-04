//
//  SettingsViewController.swift
//  TT-RSS-IOS
//
//  Created by tilomba
//  Copyright (c) 2016 tilomba. All rights reserved.
//


import UIKit
import Gloss

protocol protocolSettingsModal {
    func closedSettings()
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var SaveSettingsButton: UIBarButtonItem!
    @IBOutlet weak var CancelSettingsButton: UIBarButtonItem!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!

    internal var closeProtocol: protocolSettingsModal? = nil

    
    override func viewDidLoad() {
        print("SettingsViewController showing")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        SaveSettingsButton.action = #selector(OnSaveSettings(_:))
        CancelSettingsButton.action = #selector(OnCancelSettings(_:))
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultTTRSSURL = defaults.stringForKey("TTRSSURL")
        {
            URLTextField.text = defaultTTRSSURL
        }
        else
        {
            URLTextField.text = "http://"
        }
        if let defaultTTRSSUsername = defaults.stringForKey("TTRSSUsername")
        {
            UsernameTextField.text = defaultTTRSSUsername
        }
        if let defaultTTRSSPassword = defaults.stringForKey("TTRSSPassword")
        {
            PasswordTextField.text = defaultTTRSSPassword
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OnSaveSettings(sender: UIButton!) {
        print("Save")
        
        var url = URLTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let username = UsernameTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let password = PasswordTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if(url.isEmpty || username.isEmpty || password.isEmpty)
        {
            let alert = UIAlertController(title: "Missing Information", message: "Fill in all values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            if url.rangeOfString("http://") == nil
            {
                url = "http://" + url
            }
            if url.rangeOfString("tt-rss/api") == nil
            {
                if url.characters.last! != "/"
                {
                    url = url + "/tt-rss/api/"
                }
                else
                {
                    url = url + "tt-rss/api/"
                }
            }
            else
            {
                if url.characters.last! != "/"
                {
                    url = url + "/"
                }
            }
            print("URL: \(url)")

            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(url, forKey: "TTRSSURL")
            defaults.setObject(username, forKey: "TTRSSUsername")
            defaults.setObject(password, forKey: "TTRSSPassword")

            
            self.dismissViewControllerAnimated(true, completion: {
                if self.closeProtocol != nil
                {
                    self.closeProtocol?.closedSettings()
                }
            });
        }
    }
    
    func OnCancelSettings(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: {
            if self.closeProtocol != nil
            {
                self.closeProtocol?.closedSettings()
            }
        });
    }
    
}
