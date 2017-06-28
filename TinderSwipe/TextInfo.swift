/*// used to get the json file downloaded

import UIKit
import CoreLocation
import Foundation

let client_id = "ATKKYJPOH2QICUOFJIPDB4ADPYMX0QCUH4PSC5W1AWPQETNI" // visit developer.foursqure.com for API key
let client_secret = "OX4X2U05FUO11RIPB0D1Y4CJCOV0ESFA1YW4UH5EEQDIPMZD" // visit developer.foursqure.com for API key

let request = NSMutableURLRequest(url: URL(string: url)!)
let session = URLSession.shared

let url = "https://api.foursquare.com/v2/search/recommendations?near=Claremont,CA&v=20160607&intent=food&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"

//let picURL = "https://igx.4sqi.net/img/general/400x400/963366_J3Ywidtwi2PFreQmdcOI7ud1TKeW3eF8XeSke6K0jJs.jpg"


class TextInfo: UIViewController {
    
    //IBOutlets to display JSON text on iPhone
    @IBOutlet weak var addText: UILabel!
    @IBOutlet weak var addRating: UILabel!
    @IBOutlet weak var addPrice: UILabel!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addAddress: UILabel!
    @IBOutlet weak var addCity: UILabel!
    @IBOutlet weak var addType: UILabel!
    
    // variables for full JSON file
    var fullJson: AnyObject?
    var resultJson: AnyObject?
    var indexRestaurant: Int = 0
    var specificRestaurant: NSDictionary?
    
    // variables for each piece of information
    var JSONname: String!
    var JSONLocationType: String!
    var JSONLocationAddress: String!
    var JSONLocationCity: String!
    var JSONRating: String!
    var JSONPrice: String!
    var storeImageURLString = "" // variable to store image url prefix, dimensions, suffix, combined
    var JSONMenuID: String!
    var JSONHasMenu = ""
    var JSONMenuURL = ""
    
    // variables for data structures, profile and deck
    var profile = [String]() // an array of strings
    var deck = [[String]]() // an array of profiles
    
    //This is running functions that we created below
    override func viewDidLoad()
    {
        getJSONData()
        // as soon as the JSON file loads, getCombine is called and will run
        while fullJson == nil
        { //print("JSON is still nil")
        }
        if fullJson != nil
        {
            getResultJson(indexRestaurant: indexRestaurant)
            createDeck()
            initDeck()
            print(deck)
            //print(myJson5, " myJson5 is no longer nil!")
            //print(resultJson)
        }
    }
    
    
    //Calls to server to get Foursquare data and returns the full file as myJson5
    func getJSONData()
    {
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            let content = data!
            do
            {
                let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                //print("print from getjsondata", myJson as Any)
                self.fullJson = myJson
                //self.getCombineData()
            }
            catch
            {
            }
            //print(self.myJson5 as Any)
        }
        task.resume()
    }
    
    
    // gets the top level of the JSON file that is the same for all of the restaurants (before specific). Leaves us with a Specific5 value
    func getResultJson(indexRestaurant: Int)
    {
        if let JSONResponse = fullJson?["response"] as? NSDictionary
        {
            if let JSONGroup = JSONResponse["group"] as? NSDictionary
            {
                if let JSONResult = JSONGroup["results"] as? NSArray
                {
                    specificRestaurant = JSONResult[indexRestaurant] as? NSDictionary
                    //print(specificRestaurant as Any)
                    
                }
            }
        }
    }
    
    func resetProfile()
    {
        profile = []
    }
    
    func getLocationType() -> String
    {if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
    {
        if let JSONResponse = JSONVenue["categories"] as? NSArray
        {
            if let CategoryName = JSONResponse[0] as? NSDictionary
            {
                JSONLocationType = CategoryName["name"] as! String
            }
            
        }
        
        }
        return JSONLocationType!
    }
    
    func setLocationType()
    {
        profile.append(getLocationType())
        //print(profile)
        //print(profile[0])
    }
    
    func getName() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            JSONname = JSONVenue["name"] as! String
            //print(JSONname)
        }
        return JSONname!
    }
    
    func setName()
    {
        profile.append(getName())
        //print(profile)
        //print(profile[1])
        
    }
    
    func getLocationAddress() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if let JSONLocation = JSONVenue["location"] as? NSDictionary
            {
                JSONLocationAddress = JSONLocation["address"] as? String
            }
        }
        return JSONLocationAddress!
    }
    
    func setLocationAddress()
    {
        profile.append(getLocationAddress())
        //print(profile)
        //print(profile[2])
    }
    
    func getLocationCity() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if let JSONLocation = JSONVenue["location"] as? NSDictionary
            {
                JSONLocationCity = JSONLocation["city"] as? String
                
            }
        }
        return JSONLocationCity
    }
    
    func setLocationCity()
    {
        profile.append(getLocationCity())
        //print(profile)
        //print(profile[3])
    }
    
    func getRating() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if let JSONRatingDouble = JSONVenue["rating"] as? Double
            {
                JSONRating = String(JSONRatingDouble)
                
            }
            
        }
        
        return JSONRating
        
    }
    
    func setRating()
    {
        profile.append(getRating())
        //print(profile)
        //print(profile[4])
    }
    
    func getPrice() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if let JSONPriceGeneral = JSONVenue["price"] as? NSDictionary
            {
                JSONPrice = JSONPriceGeneral["currency"] as? String
            }
        }
        return JSONPrice
    }
    
    func setPrice()
    {
        profile.append(getPrice())
        //print(profile)
        //print(profile[5])
    }
    
    func getImageURL() -> String
    {
        if let JSONPhoto = specificRestaurant?["photo"] as? NSDictionary
        {
            if let JSONPrefix = JSONPhoto["prefix"] as? String
            {
                storeImageURLString = storeImageURLString + JSONPrefix + "300x500"
            }
            if let JSONSuffix = JSONPhoto["suffix"] as? String
            {
                storeImageURLString = storeImageURLString + JSONSuffix
            }
            
        }
        return storeImageURLString
    }
    
    func setImageURL()
    {
        profile.append(getImageURL())
        //print(profile)
        //print(profile[6])
    }
    
    func resetImageURL()
    {
        storeImageURLString = ""
    }
    
    func getMenuID() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            JSONMenuID = JSONVenue["id"] as! String?
        }
        return JSONMenuID
    }
    
    func setMenuID()
    {
        profile.append(getMenuID())
        //print(profile)
        //print(profile[7])
    }
    
    
    func getHasMenu()  -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if JSONVenue["hasMenu"] != nil {
                JSONHasMenu = "1"
            }
            else {
                JSONHasMenu = "0"
            }
        }
        return JSONHasMenu
    }
    
    func setHasMenu()
    {
        if getHasMenu() == "1" { // if the restaurant's menu is available
            JSONMenuURL = "https://foursquare.com/v/" + JSONMenuID + "/menu"
            profile.append(JSONMenuURL)
        }
            
        else {
            profile.append("Menu is not available") // if restaurant does not have menu, append the string "Menu is not available"
        }
        //print(profile)
        //print(profile[8])
    }
    
    func initDeck()
    {
        for i in 0...14
        {
            deck.append(profile)
        }
        //print(deck)
    }
    
    func createDeck() -> [[String]]
    {
        for indexRestaurant in 0...14
        {
            getResultJson(indexRestaurant: indexRestaurant)
            //print(specificRestaurant)
            setName()
            setLocationType()
            setLocationAddress()
            setLocationCity()
            setRating()
            setPrice()
            setImageURL()
            setMenuID()
            setHasMenu()
            deck.append(profile)
            
            // reset profile and imageURL
            resetProfile()
            resetImageURL()
        }
        return deck
    }

}
 */
