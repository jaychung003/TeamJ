//
//  ViewController.swift
//  loginPage2
//
//  Created by Julius Lauw on 6/29/17.
//  Copyright © 2017 Julius Lauw. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController {
    
    @IBOutlet weak var logInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        logInSegmentedControl.selectedSegmentIndex = 0
        registerButton.isHidden = true
        nameField.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }



    @IBAction func loginRegister(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            nameField.isHidden = true
            logInButton.isHidden = false
            registerButton.isHidden = true
        }
        if sender.selectedSegmentIndex == 1 {
            nameField.isHidden = false
            logInButton.isHidden = true
            registerButton.isHidden = false
        }
    }

    
    @IBOutlet weak var logInButton: UIButton!
    @IBAction func logInButton(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text else {
            print("Form is not valid")
            return
        }
        // signs in using Firebase
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }

            //successfully logged in our user
//            self.dismiss(animated: true, completion: nil)
            print("log in complete")
            self.logIn()
        })
        
    }
    func logIn() {
        performSegue(withIdentifier: "LogInIdentifier", sender: self)
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text, let name = nameField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if let error = error {
                print(error)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            // THIS IS HOW WE STORE DATA IN THE DATABASE
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                
                self.dismiss(animated: true, completion: nil) // dismiss the login page once the user has registered an account
            })
        })
    }
    
    
}

