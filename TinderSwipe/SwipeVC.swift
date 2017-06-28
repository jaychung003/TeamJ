//SwipeVC.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/15/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit

class SwipeVC: UIViewController {
    
    //restaurant profile info
    @IBOutlet weak var card: UIViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    //menu things that aren't being used right now
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var darkFillView: UIViewX!
    @IBOutlet weak var button1: UIButtonX!
    @IBOutlet weak var button2: UIButtonX!
    @IBOutlet weak var button3: UIButtonX!
    @IBOutlet weak var button4: UIButtonX!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    //button that brings to the next page
    @IBOutlet weak var nextPage: UIButton!
    
    //see menu button & hyperlink
    @IBOutlet weak var seeMenu: UIButton!
    @IBAction func menuLink(_ sender: AnyObject) {
        print(self.deck[self.cardIndex][8])
        if let url = NSURL(string: self.deck[self.cardIndex][8]) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    var deck = DataManager.sharedData.deck
    var divisor: CGFloat! //variable for angle
    var cardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61 //degree tilted
        hideButtons()
        
        nextPage.alpha = 0
        //for a few second delay of showing card's info
        card.alpha = 0
        nameLabel.alpha = 0
        typeLabel.alpha = 0
        ratingLabel.alpha = 0
        addressLabel.alpha = 0
        cityLabel.alpha = 0
        priceLabel.alpha = 0
        seeMenu.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.card.alpha = 1 //have to refer self if using outside of the brackets
        }) { (true) in
            self.showInfo()
        }
    }
    
    //populates the card with info
    func showInfo()
    {   print("did deck transfer:", deck)
        UIView.animate(withDuration: 0.1, animations: {
        self.nameLabel.text = self.deck[self.cardIndex][0]
        self.typeLabel.text = self.deck[self.cardIndex][1]
        self.ratingLabel.text = self.deck[self.cardIndex][4] + "🔥"
        self.addressLabel.text = self.deck[self.cardIndex][2]
        self.cityLabel.text = self.deck[self.cardIndex][3]
        self.priceLabel.text = self.deck[self.cardIndex][5]
        self.nameLabel.alpha = 1
        self.typeLabel.alpha = 1
        self.ratingLabel.alpha = 1
        self.addressLabel.alpha = 1
        self.cityLabel.alpha = 1
        self.priceLabel.alpha = 1
        self.seeMenu.alpha = 1

        //picture
        let url = NSURL(string:self.deck[self.cardIndex][6])
        let data = NSData(contentsOf:url! as URL)
        self.picture.image = UIImage(data: data! as Data)
        self.picture.alpha = 1
    })
    }
    
    @IBAction func loadNew(_ sender: UIButton) {
        loadNew()
    }
    func loadNew() {
        if self.cardIndex < (deck.count-1) {
            resetCard()
            self.cardIndex += 1
            showInfo()
        }
        else {
            //make a new list of restaurants that got YES swipes
            for index in 0...(DataManager.sharedData.swipes.count-1) {
                if DataManager.sharedData.swipes[index] == "YES" {
                    DataManager.sharedData.yesDeck.append(DataManager.sharedData.deck[index])
                }
            }
            print(DataManager.sharedData.swipes.count-1)
            nextPage.alpha = 1
            performSegue(withIdentifier: "youreDone", sender: self)
            performSegue(withIdentifier: "nextButton", sender: self)
            return
        }
    }

    
    @IBAction func toggleMenu(_ sender: UIButton) {
        toggleMenu()
    }
    
    //swiping action
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(1, (100/abs(xFromCenter)))
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor).scaledBy(x: scale, y: scale)
        
        
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "thumb")
            thumbImageView.tintColor = UIColor.green
            thumbImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
        else {
            thumbImageView.image = #imageLiteral(resourceName: "thumb")
            thumbImageView.tintColor = UIColor.red
            thumbImageView.transform = CGAffineTransform(rotationAngle: 3.14)
        }
        thumbImageView.alpha = abs(xFromCenter) / view.center.x
        
        //for when finger is off the screen
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                //move off to the left side of screen
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y)
                })
                loadNew()
                DataManager.sharedData.swipes.append("NO")
                print(DataManager.sharedData.swipes)
                return
            }
            else if card.center.x > (view.frame.width - 75) {
                // move off to the right side of screen
                UIView.animate(withDuration: 0.3, animations: {
                card.center = CGPoint(x: card.center.x + 200, y: card.center.y)
                })
                loadNew()
                DataManager.sharedData.swipes.append("YES")
                print(DataManager.sharedData.swipes)
                return
            }
            //bring back to center if let go in the middle range
            resetCard()
        }
    }

    @IBAction func reset(_ sender: UIButton) {
        resetCard()
    }
    func resetCard() {
            UIView.animate(withDuration: 0.2, animations: { //come back to center
                self.card.center = self.view.center
                self.thumbImageView.alpha = 0
                self.card.alpha = 1
                self.card.transform = CGAffineTransform.identity
        })
    }

}
