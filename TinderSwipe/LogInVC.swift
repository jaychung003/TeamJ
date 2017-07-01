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
    @IBOutlet weak var usernameField: UITextField!
    
    //establishes the alerts that correspond with location privileges
    var action = UIAlertAction()
    var alertView = UIAlertController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        logInSegmentedControl.selectedSegmentIndex = 0
        registerButton.isHidden = true
        nameField.isHidden = true
        usernameField.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }



    @IBAction func loginRegister(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            nameField.isHidden = true
            logInButton.isHidden = false
            registerButton.isHidden = true
            usernameField.isHidden = true
        }
        if sender.selectedSegmentIndex == 1 {
            nameField.isHidden = false
            logInButton.isHidden = true
            registerButton.isHidden = false
            usernameField.isHidden = false
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
    func isValid(name: String) -> Bool {
        // check the name is between 4 and 16 characters
        if !(4...16 ~= name.characters.count) {
            return false
        }
        
//STILL NEED TO ADD MORE ERROR THROWING CONDITIONS FOR USERNAME, EMAIL, ETC.
//        // check that name doesn't contain whitespace or newline characters
//        let range = name.rangeOfCharacterFromSet(.whitespaceAndNewlineCharacterSet())
//        if let range = range where range.startIndex != range.endIndex {
//            return false
//        }
        
        return true
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: UIButton) {
        guard let email = emailField.text else {
            alertView = UIAlertController(title: "Invalid E-mail", message: "Please type in a valid e-mail", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        guard let password = passwordField.text else {
            alertView = UIAlertController(title: "Invalid Password", message: "Please type in a valid password with 6 or more characters", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        guard let name = nameField.text else {
            alertView = UIAlertController(title: "Invalid Name", message: "Please type in your name", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        guard let username = usernameField.text, isValid(name: username) else {
            alertView = UIAlertController(title: "Invalid Username", message: "Please type in a valid username between 4 and 16 characters", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
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
            let values = ["name": name, "email": email, "username": username]
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

