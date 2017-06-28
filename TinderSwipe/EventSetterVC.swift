//
//  EventSetterVC.swift
//  UserInput+Json
//
//  Created by Joshua Guggenheim on 6/20/17.
//  Copyright © 2017 Josh Guggeheim. All rights reserved.
//

import UIKit
import CoreLocation

class EventSetterVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

//IBOutlets to collect user input
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var myLocation: UIButton!
    
//establishes variables to store location data (longitude and latitude)
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var flag = true
   
//establishes the alerts that correspond with location privileges
    
    var action = UIAlertAction()
    var alertView = UIAlertController()

//IBAction that sets location based on urlHERE, gets the JSONData file, and createsDeck from it 
    
    @IBAction func setLocation(_ sender: UIButton) {
        let url = DataManager.sharedData.urlHERE
        DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
        DataManager.sharedData.getJSONData()
        while DataManager.sharedData.fullJson == nil {
        }
        DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
        DataManager.sharedData.createDeck()
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
    }
    
//sets current location to the last known location coordinate stored
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if flag {
            currentLocation = locations.last?.coordinate
            flag = false
        }
    }
    
//shows location request alert. Can customize message here.
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Disabled", message: "Please enable location services", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    }

//When the date label is selected, show date scroll and hide type scroll
    
    func tap2(gestureRecognizer: UITapGestureRecognizer) {
        self.dismissKeyboard()
        self.hideKeyboard()
        datePicker.isHidden = false
        pickerView.isHidden = true
        cityField.resignFirstResponder()
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
    
    @IBAction func clickMyLocation(_ sender: Any)
{
        getCurrentLocation()
        pickerView.isHidden = true
        datePicker.isHidden = true
        DataManager.sharedData.eventName = eventNameField.text!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
        {

// if statement allows time for currentLocation to no longer be nil. We could probably approach this differently

        if self.currentLocation == nil
        {
        print("clickmylocation is nil")
        }
        else
            {
            if (DataManager.sharedData.eventName.isEmpty || DataManager.sharedData.eventDateAndTime.isEmpty || DataManager.sharedData.venueType.isEmpty) == true
                    {   self.alertView = UIAlertController(title: "Incomplete Information", message: "Please make sure the event's NAME, DATE, TIME, and VENUE TYPE, are completed.", preferredStyle: .alert)
                        self.action = UIAlertAction(title: "Let's Add Them!", style: .default, handler: { (alert) in })
                        self.alertView.addAction(self.action)
                        self.present(self.alertView, animated: true, completion: nil)
                    }
                    else {
                        DataManager.sharedData.urlHERE = "https://api.foursquare.com/v2/search/recommendations?ll=\(self.currentLocation.latitude),\(self.currentLocation.longitude)&v=20160607&intent=\(DataManager.sharedData.venueType)&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"
                let url = DataManager.sharedData.urlHERE
                DataManager.sharedData.request = NSMutableURLRequest(url: URL(string: url)!)
                DataManager.sharedData.getJSONData()

// while statement allows for time for fullJson to populate
                
                while DataManager.sharedData.fullJson == nil {
                    print("JSON IS NIL")
                }
                DataManager.sharedData.getResultJson(indexRestaurant: DataManager.sharedData.indexRestaurant)
                DataManager.sharedData.createDeck()

//This is the transition to the next VC

                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipeVCID")
                self.present(nextViewController, animated:true, completion:nil)
                        }
            
            }
            
        }
}
    
//One click of this button takes user input, sets urlHERE, makes deck, and transitions to next ViewController
    @IBAction func getManualURL(_ sender: UIButton) {
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
        else {
            DataManager.sharedData.makeMyURL()
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
