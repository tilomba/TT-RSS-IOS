
import Foundation
import Gloss
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TTRSSGetFeedsResponse: Decodable {
	public var seq : Int?
	public var status : Int?
	public var content : [TTRSSFeeds]?//Array<TTRSSFeeds>?

    public required init?(json: JSON) {
        seq = ("seq" <~~ json)!
        status = ("status" <~~ json)!
        content = "content" <~~ json
    }
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TTRSSGetFeedsResponse]
    {
        var models:[TTRSSGetFeedsResponse] = []
        for item in array
        {
            models.append(TTRSSGetFeedsResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		seq = dictionary["seq"] as? Int
		status = dictionary["status"] as? Int
		if (dictionary["content"] != nil) { content = TTRSSFeeds.modelsFromDictionaryArray(dictionary["content"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.seq, forKey: "seq")
		dictionary.setValue(self.status, forKey: "status")

		return dictionary
	}

}