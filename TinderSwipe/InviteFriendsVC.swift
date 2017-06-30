//
//  InviteFriendsVC.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/30/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupMembers = [String]()
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonClicked(_ sender: Any) {
        handleAddButton()
    }
    
    func handleAddButton() {
        //don't do anything if nothing is typed in
        if userNameField.text == "" {
            print("put in a username")
            return
        }
        //don't do anything if username is already a group member
        if groupMembers.contains(userNameField.text!) == true {
            print("username already in the group")
            return
        }
        //append entered username to the list if the textfield is not empty
        else {
            groupMembers.append(userNameField.text!)
            print(groupMembers)
            self.tableView.reloadData()
            userNameField.text = ""
        }
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
        
    }
    
}
