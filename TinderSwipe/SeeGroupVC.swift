//
//  SeeGroupVC.swift
//  loginPage2
//
//  Created by cssummer17 on 6/29/17.
//  Copyright © 2017 Julius Lauw. All rights reserved.
//

import UIKit
import Firebase

class SeeGroupVC: UIViewController {

    @IBOutlet weak var navBarUserName: UINavigationItem!

    @IBAction func createEvent(_ sender: Any) {
        print("event button clicked")
        handleCreateEvent()
    }
    
    @IBAction func inviteFriends(_ sender: Any) {
        print("inviting firends")
        handleInviteFriends()
    }
    
    func handleInviteFriends() {
        performSegue(withIdentifier: "InviteFriendsIdentifier", sender: self)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        handleLogout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            // THIS IS HOW WE FETCH DATA FROM THE DATABASE!!!
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (DataSnapshot) in
                print(DataSnapshot)
                print(uid)
                if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                    self.navBarUserName.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth()
                .signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "LogOutIdentifier", sender: self)
    }
    
    func handleCreateEvent() {
        performSegue(withIdentifier: "CreateEventIdentifier", sender: self)
    }
}
