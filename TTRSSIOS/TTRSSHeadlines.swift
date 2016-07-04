/*
Copyright (c) 2016 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import Gloss

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TTRSSHeadlines: Decodable {
	public var id : Int?
	public var unread : Bool?
	public var marked : String?
	public var published : String?
	public var updated : Int?
	public var is_updated : String?
	public var title : String?
	public var link : String?
	public var feed_id : Int?
	public var tags : [String]?
	public var labels : [String]?
	public var feed_title : String?
	public var comments_count : Int?
	public var comments_link : String?
	public var always_display_attachments : String?
	public var author : String?
	public var score : Int?
	public var note : String?
	public var lang : String?

    public required init?(json: JSON) {
        id = "id" <~~ json
        unread = "unread" <~~ json
        marked = "marked" <~~ json
        published = "published" <~~ json
        updated = "updated" <~~ json
        is_updated = "is_updated" <~~ json
        title = "title" <~~ json
        link = "link" <~~ json
        feed_id = "feed_id" <~~ json
        tags = "tags" <~~ json
        labels = "labels" <~~ json
        feed_title = "feed_title" <~~ json
        comments_count = "comments_count" <~~ json
        comments_link = "comments_link" <~~ json
        comments_link = "comments_link" <~~ json
        always_display_attachments = "always_display_attachments" <~~ json
        author = "author" <~~ json
        score = "score" <~~ json
        note = "note" <~~ json
        lang = "lang" <~~ json
    }
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let content_list = Content.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Content Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TTRSSHeadlines]
    {
        var models:[TTRSSHeadlines] = []
        for item in array
        {
            models.append(TTRSSHeadlines(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let content = Content(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Content Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		unread = dictionary["unread"] as? Bool
		marked = dictionary["marked"] as? String
		published = dictionary["published"] as? String
		updated = dictionary["updated"] as? Int
		is_updated = dictionary["is_updated"] as? String
		title = dictionary["title"] as? String
		link = dictionary["link"] as? String
		feed_id = dictionary["feed_id"] as? Int
//		if (dictionary["tags"] != nil) { tags = Tags.modelsFromDictionaryArray(dictionary["tags"] as! NSArray) }
//		if (dictionary["labels"] != nil) { labels = Labels.modelsFromDictionaryArray(dictionary["labels"] as! NSArray) }
        if(dictionary["tags"] != nil)
        {
            tags = dictionary["tags"] as? [String]
        }
        if(dictionary["labels"] != nil)
        {
            labels = dictionary["labels"] as? [String]
        }
		feed_title = dictionary["feed_title"] as? String
		comments_count = dictionary["comments_count"] as? Int
		comments_link = dictionary["comments_link"] as? String
		always_display_attachments = dictionary["always_display_attachments"] as? String
		author = dictionary["author"] as? String
		score = dictionary["score"] as? Int
		note = dictionary["note"] as? String
		lang = dictionary["lang"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.unread, forKey: "unread")
		dictionary.setValue(self.marked, forKey: "marked")
		dictionary.setValue(self.published, forKey: "published")
		dictionary.setValue(self.updated, forKey: "updated")
		dictionary.setValue(self.is_updated, forKey: "is_updated")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.link, forKey: "link")
		dictionary.setValue(self.feed_id, forKey: "feed_id")
		dictionary.setValue(self.feed_title, forKey: "feed_title")
		dictionary.setValue(self.comments_count, forKey: "comments_count")
		dictionary.setValue(self.comments_link, forKey: "comments_link")
		dictionary.setValue(self.always_display_attachments, forKey: "always_display_attachments")
		dictionary.setValue(self.author, forKey: "author")
		dictionary.setValue(self.score, forKey: "score")
		dictionary.setValue(self.note, forKey: "note")
		dictionary.setValue(self.lang, forKey: "lang")

		return dictionary
	}

}