//
//  resultVC.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/21/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit

class resultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wholeDeck = [[String]]()
    var swipeResult = DataManager.sharedData.swipes
    var yesDeck = DataManager.sharedData.yesDeck
    var myIndex = 0
    var venueName = ""
    var foursquarePageUrl = ""
    var venueID = ""
    
    override func viewDidLoad() {
        print(swipeResult)
        print(yesDeck)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yesDeck.count
    }
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRestaurant", for: indexPath)
        
        let restaurant = yesDeck[indexPath.row]
        cell.textLabel?.text = restaurant[0] //name of restaurant in each cell
        cell.detailTextLabel?.text = restaurant[1] + "\n" + restaurant[2] + ", " + restaurant[3] + "\n" + restaurant[4] + "🔥" + "  " + restaurant[5] //detailed info
        
        
        //pull image from url and set it as the image in each cell
        let url = NSURL(string:yesDeck[indexPath.row][6])
        let data = NSData(contentsOf:url! as URL)
        let restImage = UIImage(data: data! as Data)

        cell.imageView!.image = restImage

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        venueName = DataManager.sharedData.JSONname
        venueID = DataManager.sharedData.JSONMenuID
        venueName = venueName.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        venueName = venueName.lowercased()
        foursquarePageUrl = "https://foursquare.com/v/" + venueName + "/" + venueID
        print(foursquarePageUrl)
        UIApplication.shared.openURL(URL(string: foursquarePageUrl)!)
    }
}
