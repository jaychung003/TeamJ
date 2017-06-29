//
//  EventSetterVC.swift
//  UserInput+Json
//
//  Created by Joshua Guggenheim on 6/20/17.
//  Copyright © 2017 Josh Guggeheim. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class EventSetterVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

//IBOutlets to collect user input
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    
//establishes variables to store location data (longitude and latitude)
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var flag = true
   
//establishes the alerts that correspond with location privileges
    
    var action = UIAlertAction()
    var alertView = UIAlertController()

//IBAction called when "Create Event" clicked; sets location based on urlHERE, gets the JSONData file, and createsDeck from it
    
    @IBAction func setLocation(_ sender: UIButton) {
        let url = DataManager.sharedData.urlHERE
        DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
        DataManager.sharedData.getJSONData()
        while DataManager.sharedData.fullJson == nil {
        }
        DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
        DataManager.sharedData.createDeck()
        //storing event name to database
//        let ref = Database.database().reference()
//        let eventNameReference = ref.child("eventName")
//        let values = ["eventName": eventNameField.text]
//        eventNameReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            if let err = err {
//                print(err)
//                return
//            }
//    })
        
//        uploadGroupName()
//    }
//    func uploadGroupName() {
//        var databaseRef: DatabaseReference!
//        databaseRef = Database.database().reference() // sets up reference to the Firebase database
//        var groupInfo: [String: Any]
//        groupInfo = ["eventName": "test event"]
//        databaseRef.child("myGroups").childByAutoId().setValue(groupInfo)
//        print("groupInfo:", groupInfo)
    }
    
    
    
//ViewDidLoad func requests user location privileges, hides scroll pickers, creates a "tap" zone for scrollers

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        pickerView.isHidden = true
        datePicker.isHidden = true
        view.addSubview(pickerView)
        view.addSubview(datePicker)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(gestureRecognizer:)))
        let tap2 = UITapGestureRecognizer(target: self
            , action: #selector(self.tap2(gestureRecognizer:)))
        label.addGestureRecognizer(tap)
        dateLabel.addGestureRecognizer(tap2)
        label.isUserInteractionEnabled = true
        dateLabel.isUserInteractionEnabled = true
        datePicker.backgroundColor = hexStringToUIColor(hex: "#46B1AA")
        dateLabel.layer.cornerRadius = 5
        dateLabel.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        okButton.isHidden = true
        okButton.layer.cornerRadius = 7
        label.textColor = UIColor.black
        dateLabel.textColor = UIColor.black
        cityField.textColor = UIColor.black
        stateField.textColor = UIColor.black
        eventNameField.textColor = UIColor.black
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//method called when my location button clicked. Ensures that location services are enabled. If not, Alerts user
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                showLocationAlert()
            }
        } else {
            showLocationAlert()
        }
        areFieldsFilled()
    }
    
//sets current location to the last known location coordinate stored
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if flag {
            currentLocation = locations.last?.coordinate
            DataManager.sharedData.myCurrentLocation = currentLocation
            flag = false
        }
        areFieldsFilled()
    }
    
//shows location request alert. Can customize message here.
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Disabled", message: "Please enable location services", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        areFieldsFilled()
    }
    
//sets up date selection scroll. Provides format and flexibility in variable storage
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        pickerView.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        DataManager.sharedData.eventDate = formatter.string(from: datePicker.date)
        formatter.dateFormat = "hh:mm a"
        DataManager.sharedData.eventTime = formatter.string(from: datePicker.date)
        DataManager.sharedData.eventDateAndTime = DataManager.sharedData.eventDate + " " + DataManager.sharedData.eventTime
        dateLabel.text = DataManager.sharedData.eventDateAndTime
    }
    
//When the type label is selected, show type scroll and hide date scroll
    
    func tap(gestureRecognizer: UITapGestureRecognizer) {
        self.dismissKeyboard()
        self.hideKeyboard()
        pickerView.isHidden = false
        datePicker.isHidden = true
        cityField.resignFirstResponder()
        
        areFieldsFilled()
    }

//When the date label is selected, show date scroll and hide type scroll
    
    func tap2(gestureRecognizer: UITapGestureRecognizer) {
        self.dismissKeyboard()
        self.hideKeyboard()
        datePicker.isHidden = false
        pickerView.isHidden = true
        cityField.resignFirstResponder()
        self.areFieldsFilled()
        
    }
    
//Various info to set up pickerView scroll
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.sharedData.eventType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataManager.sharedData.eventType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DataManager.sharedData.venueType = DataManager.sharedData.eventType[row]
        label.text = DataManager.sharedData.venueType
        DataManager.sharedData.venueType = DataManager.sharedData.venueType.lowercased()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//One click of this button gets current locations, sets urlHERE, makes deck, and transitions to next ViewController
    @IBAction func fillWithMyLocation(_ sender: UIButton) {
        datePicker.isHidden = true
        pickerView.isHidden = true
        cityField.text! = "Here"
        stateField.text! = "Here"
        areFieldsFilled()
    }
 
    
func areFieldsFilled()
{
    if (DataManager.sharedData.eventState.isEmpty && DataManager.sharedData.eventCity.isEmpty && DataManager.sharedData.eventName.isEmpty && DataManager.sharedData.eventDateAndTime.isEmpty && DataManager.sharedData.venueType.isEmpty) == false
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.25){self.okButton.isHidden = false}
    }
    
}
    
//One click of this button takes user input, sets urlHERE, makes deck, and transitions to next ViewController
    @IBAction func getManualURL(_ sender: UIButton) {
        datePicker.isHidden = true
        pickerView.isHidden = true
        DataManager.sharedData.eventName = eventNameField.text!
        DataManager.sharedData.eventCity = cityField.text!
        DataManager.sharedData.eventState = stateField.text!
        pickerView.isHidden = true
        datePicker.isHidden = true
        
        if (DataManager.sharedData.eventState.isEmpty || DataManager.sharedData.eventCity.isEmpty || DataManager.sharedData.eventName.isEmpty || DataManager.sharedData.eventDateAndTime.isEmpty || DataManager.sharedData.venueType.isEmpty) == true
        {   alertView = UIAlertController(title: "Incomplete Information", message: "Please make sure the event's NAME, DATE, CITY, STATE, TIME, and VENUE TYPE, are completed.", preferredStyle: .alert)
            action = UIAlertAction(title: "Let's Add Them!", style: .default, handler: { (alert) in })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
        
        if ((cityField.text! == "Here") && (stateField.text! == "Here"))
        {
            getCurrentLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            DataManager.sharedData.makeMyLocationURL()
            let url = DataManager.sharedData.urlHERE
            print(url)
            DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
            DataManager.sharedData.getJSONData()
            
            // while statement allows for time for fullJson to populate
            
            while DataManager.sharedData.fullJson == nil {
                print("JSON IS LLL")
            }
            print("We left the while loop")
            print(self.currentLocation)
            DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
            print("Hello World")
            DataManager.sharedData.createDeck()
            print("We created a deck", DataManager.sharedData.deck)
            //This is the transition to the next VC
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipeVCID")
            self.present(nextViewController, animated:true, completion:nil)
            }}

        else {
            okButton.isHidden = false
            DataManager.sharedData.makeInputLocationURL()
            let url = DataManager.sharedData.urlHERE
            DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
            DataManager.sharedData.getJSONData()
            
// while statement allows for time for fullJson to populate

            while DataManager.sharedData.fullJson == nil {
            }
            DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
            DataManager.sharedData.createDeck()
            
//This is the transition to the next VC

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipeVCID")
            self.present(nextViewController, animated:true, completion:nil)
        }
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference() // sets up reference to the Firebase database
        var groupInfo: [String: Any]
        groupInfo = ["eventName": eventNameField.text]
        databaseRef.child("myGroups").childByAutoId().setValue(groupInfo)
    }

}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap3)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
