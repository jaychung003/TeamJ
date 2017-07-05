//
//  DataManager.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/27/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

let client_id = "ATKKYJPOH2QICUOFJIPDB4ADPYMX0QCUH4PSC5W1AWPQETNI" // visit developer.foursqure.com for API key
let client_secret = "OX4X2U05FUO11RIPB0D1Y4CJCOV0ESFA1YW4UH5EEQDIPMZD" // visit developer.foursqure.com for API key

class DataManager: NSObject {
    static let sharedData = DataManager()
    
    //initial variables for user input
    var venueType = ""
    var eventDate = ""
    var eventTime = ""
    var eventDateAndTime = ""
    var eventName = ""
    var eventCity = ""
    var eventState = ""
    var URLtoPass = String()
    var URLtoPassNoSpace = ""
    var urlHERE = ""
    var myCurrentLocation = CLLocationCoordinate2D()
    var eventType = ["Drinks","Food","Breakfast","Brunch","Lunch","Coffee","Dinner","Dessert"]

    var PriceAndTier = String()
    var llURL = ""
    
    //variables for creating JSON file
    let session = URLSession.shared
    var request: NSMutableURLRequest?
    
    // variables for full JSON file
    var fullJson: AnyObject?
    var resultJson: AnyObject?
    var indexRestaurant = 0
    var specificRestaurant: NSDictionary?
    
    //price array variable
    var priceArray:[Int] = []
    
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
    var JSONTier: Int!
    var cardTierValue = 0
    var JSONVenueID: String!
    
    // variables for data structures, card and deck
    var card = [String]() // an array of strings
    var deck = [[String]]() // an array of cards
    var swipes = [String]() //an array of YES or NO swipes
    var yesDeck = [[String]]() //an array of cards with YES swipes
    
    //Calls to server to get Foursquare data and returns the full file as myJson5
    func getJSONData()
    {
        let task = session.dataTask(with: request! as URLRequest) {(data, response, error) in
            let content = data!
            do
            {
                let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                self.fullJson = myJson
                print(self.fullJson)
            }
            catch
            {
            }
        }
        task.resume()
    }
    
    func addRemoveValue(dollarSignValue: Int)
    {
        if (priceArray.contains(dollarSignValue))
        {priceArray = priceArray.filter
            {
                $0 != dollarSignValue

            }
            print(priceArray)
        }
        else{
            priceArray.append(dollarSignValue)
            print(priceArray)
        }
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
    
    //creates Deck
    func createDeck() -> [[String]]
    {
        var count = 0
        while count < 15
        {
            getResultJson(indexRestaurant: indexRestaurant)
            getPrice()
            print("CardTierValue",cardTierValue)
            if priceArray.contains(cardTierValue)
            {
            getJSONVenueID()
            setName()
            setLocationType()
            setLocationAddress()
            setLocationCity()
            setRating()
            setPrice()
            setImageURL()
            setMenuID()
            setHasMenu()
            deck.append(card)
            count = count + 1
            // reset card and imageURL
            resetCard()
            resetImageURL()
            }
            indexRestaurant = indexRestaurant + 1
        }
        return deck
    }
    
    //takes user input location and generates foursquare url
    func makeInputLocationURL()  {
        URLtoPass =  "https://api.foursquare.com/v2/search/recommendations?near=\(eventCity),\(eventState)&v=20160607&intent=\(venueType)&limit=50&client_id=\(client_id)&client_secret=\(client_secret)"
        URLtoPassNoSpace = URLtoPass.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        urlHERE = URLtoPassNoSpace
        print("This is makemyURL", urlHERE)
    }
    
    func makeMyLocationURL()
    {
        urlHERE = "https://api.foursquare.com/v2/search/recommendations?ll=\(myCurrentLocation.latitude),\(myCurrentLocation.longitude)&v=20160607&intent=\(venueType)&limit=50&client_id=\(client_id)&client_secret=\(client_secret)"
        print("This is makemyURL", urlHERE)
   
    }
    
    func resetCard()
    {
        card = []
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
            if JSONLocationType == nil
            {
                JSONLocationType = "N/A"
                return JSONLocationType
            }
            
        }
        
        }
        return JSONLocationType!
    }
    
    func setLocationType()
    {
        card.append(getLocationType())

    }
    
    func getName() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            JSONname = JSONVenue["name"] as! String
        }
        if JSONname == nil
        {
            JSONname = "N/A"
            return JSONname
        }
        return JSONname!
    }
    
    func setName()
    {
        card.append(getName())
    }
    
    func getJSONVenueID() -> String
    {
        getMenuID()
        print("Try this as the id:", JSONMenuID)
        return ""
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
        if JSONLocationAddress == nil
        {
            JSONLocationAddress = "N/A"
            return JSONLocationAddress
        }
        return JSONLocationAddress
    }
    
    
    func setLocationAddress()
    {
        card.append(getLocationAddress())
    }
    
    func getLocationCity() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            print(JSONVenue)
            if let JSONLocation = JSONVenue["location"] as? NSDictionary
            {
                print(JSONLocation)
                JSONLocationCity = JSONLocation["city"] as? String
                print(JSONLocationCity)
            }
            if JSONLocationCity == nil
            {
                JSONLocationCity = "N/A"
                return JSONLocationCity
            }
        }
        return JSONLocationCity!
    }
    
    func setLocationCity()
    {
        card.append(getLocationCity())
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
        if JSONRating == nil
        {
            JSONRating = "N/A"
            return JSONRating
        }
        return JSONRating
        
    }
    
    func setRating()
    {
        card.append(getRating())
    }
    
    func getPrice() -> String
    {
        if let JSONVenue = specificRestaurant?["venue"] as? NSDictionary
        {
            if let JSONPriceGeneral = JSONVenue["price"] as? NSDictionary
            {
                JSONTier = JSONPriceGeneral["tier"] as? Int
                cardTierValue = JSONTier
                print("JSONTIER is: ", JSONTier)
            }
        }
        if JSONPrice == nil || JSONTier == nil
        {
            JSONPrice = "N/A"
            //Let's say that any venue without a tier is a 1
            JSONTier = 1
        }
        for numbers in 1...cardTierValue
        {
            PriceAndTier = PriceAndTier + "$"
        }
        print("Price and Tier to be Returned", PriceAndTier)
        return (PriceAndTier)
    }
    
    func setPrice()
    {
        PriceAndTier = ""
        JSONTier = 1
        card.append(getPrice())
        //print(card)
        //print(card[5])
    }
    
    func getImageURL() -> String
    {
        if let JSONPhoto = specificRestaurant?["photo"] as? NSDictionary
        {
            if let JSONPrefix = JSONPhoto["prefix"] as? String
            {
                storeImageURLString = storeImageURLString + JSONPrefix + "480x400"
            }
            if let JSONSuffix = JSONPhoto["suffix"] as? String
            {
                storeImageURLString = storeImageURLString + JSONSuffix
            }
            
        }
        if storeImageURLString == nil
        {
            storeImageURLString = "N/A"
            return storeImageURLString
        }
        return storeImageURLString
    }
    
    func setImageURL()
    {
        card.append(getImageURL())
        //print(card)
        //print(card[6])
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
        if JSONMenuID == nil
        {
            JSONMenuID = "N/A"
            return JSONMenuID
        }
        return JSONMenuID
    }
    
    func setMenuID()
    {
        card.append(getMenuID())
        //print(card)
        //print(card[7])
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
        if JSONHasMenu == nil
        {
            JSONHasMenu = "N/A"
            return JSONHasMenu
        }
        return JSONHasMenu
    }
    
    func setHasMenu()
    {
        if getHasMenu() == "1" { // if the restaurant's menu is available
            JSONMenuURL = "https://foursquare.com/v/" + JSONMenuID + "/menu"
            card.append(JSONMenuURL)
        }
            
        else {
            card.append("Menu is not available") // if restaurant does not have menu, append the string "Menu is not available"
        }

    }
    
}


