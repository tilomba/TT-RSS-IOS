

import Foundation
import Gloss


public class TTRSSFeeds: Decodable {
	public var id : Int?
	public var title : String?
	public var unread : String?
	public var cat_id : Int?

    
    public required init?(json: JSON) {
        id = "id" <~~ json
        title = "title" <~~ json
        unread = "unread" <~~ json
        cat_id = "cat_id" <~~ json
    }
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let content_list = Content.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Content Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TTRSSFeeds]
    {
        var models:[TTRSSFeeds] = []
        for item in array
        {
            models.append(TTRSSFeeds(dictionary: item as! NSDictionary)!)
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
		title = dictionary["title"] as? String
		unread = dictionary["unread"] as? String
		cat_id = dictionary["cat_id"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.unread, forKey: "unread")
		dictionary.setValue(self.cat_id, forKey: "cat_id")

		return dictionary
	}

}