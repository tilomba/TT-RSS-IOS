//
//  HeadlineTableItem.swift
//  TT-RSS-IOS
//
//  Created by tilomba
//  Copyright (c) 2016 tilomba. All rights reserved.
//


import Foundation
import Gloss


public struct HeadlineTableItem: Decodable {
    

    
    public var identifer: NSString = ""
    public var title: NSString = ""
    public var link: NSString = ""
    public var date: NSDate!
    public var updated: NSDate!
    public var summary: NSString = ""
    public var content: NSString = ""
    public var author: NSString = ""
    public var unread: Bool = false
    public var articleId: Int = 0
    // Enclosures: Holds 1 or more item enclosures (i.e. podcasts, mp3. pdf, etc)
    //  - NSArray of NSDictionaries with the following keys:
    //     url: where the enclosure is located (NSString)
    //     length: how big it is in bytes (NSNumber)
    //     type: what its type is, a standard MIME type  (NSString)
    //    NSArray *enclosures;
    public var enclosures: NSArray = []
    
    public init?() {
    }
    
    public init?(json: JSON) {
        identifer = ("identifer" <~~ json)!
        title = ("title" <~~ json)!
        link = ("link" <~~ json)!
        date = "date" <~~ json
        updated = "updated" <~~ json
        summary = ("summary" <~~ json)!
        content = ("content" <~~ json)!
        author = ("author" <~~ json)!
    }
}
