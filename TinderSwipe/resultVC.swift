//
//  resultVC.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/21/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit

class resultVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var wholeDeck = [[String]]()
    var swipeResult = DataManager.sharedData.swipes
    var yesDeck = DataManager.sharedData.yesDeck
    var myIndex = 0
    var venueName = ""
    var foursquarePageUrl = ""
    var venueID = ""
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        print(swipeResult)
        print(yesDeck)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.resultsTableView.addGestureRecognizer(longPressGesture)    }
    
    func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.resultsTableView)
        let indexPath = self.resultsTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            print("Long press on row, at \(indexPath!.row)")
            let busPhone = 4157136798
                if let urlTest = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(urlTest) {
                                UIApplication.shared.open(urlTest)
        }
    }
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
        
        var restaurant = yesDeck[indexPath.row]
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
        var restaurant2 = yesDeck[indexPath.row]
        myIndex = indexPath.row
        venueName = restaurant2[0].replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        venueName = venueName.lowercased()
        foursquarePageUrl = "https://foursquare.com/v/" + venueName + "/" + restaurant2[7]
        print(foursquarePageUrl)
       UIApplication.shared.openURL(URL(string: foursquarePageUrl)!)
        }
    }

