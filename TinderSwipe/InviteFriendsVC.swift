//
//  InviteFriendsVC.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/30/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class InviteFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let group1 = Group()
    var groupMembers = Group().listOfMembers
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonClicked(_ sender: Any) {
        handleAddButton()
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        handleDoneInviting()
    }
    
    var action = UIAlertAction()
    var alertView = UIAlertController()
    var allUsernames = [String]()
    
    func handleDoneInviting() {
        //upload data to database to share with the group
        handleDeckCreating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        self.uploadNewGroupWithMembers()
        self.performSegue(withIdentifier: "DoneInvitingIdentifier", sender: self)
        }
    }
    
    func handleDeckCreating() {
        DataManager.sharedData.makeInputLocationURL()
        let url = DataManager.sharedData.urlHERE
        DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
        DataManager.sharedData.getJSONData()
        
        // while statement allows for time for fullJson to populate
        
        while DataManager.sharedData.fullJson == nil {
        }
        DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
        //DataManager.sharedData.createDeck()
    }
    
    func uploadNewGroupWithMembers() {
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference() // sets up reference to the Firebase database
        var groupInfo: [String: Any]
        groupInfo = ["members": group1.listOfMembers, "event name": DataManager.sharedData.eventName, "deck": DataManager.sharedData.deck]
        databaseRef.child("myGroups").childByAutoId().setValue(groupInfo)
    }
    
    func handleAddButton() {
        //pop up an error message if nothing is typed in
        if userNameField.text == "" {
            alertView = UIAlertController(title: "Invalid Username", message: "Please put in a valid username", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        //pop up an error message if username is already a group member
        if groupMembers.contains(userNameField.text!) == true {
            alertView = UIAlertController(title: "Invalid Username", message: "The user is already in your group!", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        //pop up an error message if username is not registered
        if allUsernames.contains(userNameField.text!) == false {
            alertView = UIAlertController(title: "Invalid Username", message: "Please put in a valid username", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
            
        //append entered username to the list if the textfield is not empty
        else {
            groupMembers.append(userNameField.text!)
            print(groupMembers)
            self.tableView.reloadData()
            userNameField.text = ""
            group1.listOfMembers = groupMembers
            print("group1.listOfMembers: ", group1.listOfMembers)
        }
    }
        func fetchUsernames() -> [String] {
            Database.database().reference().child("users").observe(.childAdded, with: { (DataSnapshot) in
    
                if let dictionary = DataSnapshot.value as? [String: AnyObject] {
//                    let groupInstance = Group()
//                    groupInstance.groupName = dictionary["eventName"] as! String
//                    print(groupInstance.groupName)
                    print("Datasnapshot:  ", DataSnapshot)
                    print("dictionary: ", dictionary)
                    self.allUsernames.append(dictionary["username"] as! String)
                }
            }
                , withCancel: nil)
            return allUsernames
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usernameCell", for: indexPath)
        cell.textLabel?.text = groupMembers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    override func viewDidLoad() {
        fetchUsernames()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            print("all users: ", self.allUsernames)
        }
    }
    
}
