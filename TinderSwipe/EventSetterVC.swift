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
    
    @IBOutlet weak var diningLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nextStep: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var myLocationIconButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var andLabel: UILabel!
    
   
// IBOutlets to collect price range data
    
    @IBOutlet weak var SearchOne: UIButton!
    @IBOutlet weak var SearchTwo: UIButton!
    @IBOutlet weak var SearchThree: UIButton!
    @IBOutlet weak var SearchFour: UIButton!
    
// keep track of what step we're on
    var stepValue = 0
    
   
    
//establishes variables to store location data (longitude and latitude)
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var flag = true
   
//establishes the alerts that correspond with location privileges
    
    var action = UIAlertAction()
    var alertView = UIAlertController()
    
//IBAction to increment stepValue

    @IBAction func incrementStepValue(_ sender: UIButton) {
        self.hideKeyboard()
        self.dismissKeyboard()
        if stepValue == 0
        {
            eventNameField.isHidden = true
            cityField.isHidden = false
            stateField.isHidden = false
            orLabel.isHidden = false
            myLocationIconButton.isHidden = false
            dateLabel.isHidden = true
            diningLabel.isHidden = true
            pickerView.isHidden = true
            datePicker.isHidden = true
            SearchOne.isHidden = true
            SearchTwo.isHidden = true
            SearchThree.isHidden = true
            SearchFour.isHidden = true
            okButton.isHidden = true
            andLabel.isHidden = false
            stepLabel.text! = "Search by City and State or Current Location"

        }
        if stepValue == 1
        {
            self.hideKeyboard()
            self.dismissKeyboard()
            eventNameField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            orLabel.isHidden = true
            myLocationIconButton.isHidden = true
            dateLabel.isHidden = false
            diningLabel.isHidden = true
            pickerView.isHidden = true
            datePicker.isHidden = false
            SearchOne.isHidden = true
            SearchTwo.isHidden = true
            SearchThree.isHidden = true
            SearchFour.isHidden = true
            okButton.isHidden = true
            andLabel.isHidden = true
            stepLabel.text! = "Select a Time and Date for Your Event"

        }
        if stepValue == 2
        {
            self.hideKeyboard()
            self.dismissKeyboard()
            eventNameField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            orLabel.isHidden = true
            myLocationIconButton.isHidden = true
            dateLabel.isHidden = true
            diningLabel.isHidden = false
            pickerView.isHidden = false
            datePicker.isHidden = true
            SearchOne.isHidden = true
            SearchTwo.isHidden = true
            SearchThree.isHidden = true
            SearchFour.isHidden = true
            okButton.isHidden = true
            andLabel.isHidden = true
            stepLabel.text! = "Select a Type of Dining for Your Event"

        }
        if stepValue == 3
        {
            self.hideKeyboard()
            self.dismissKeyboard()
            eventNameField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            orLabel.isHidden = true
            myLocationIconButton.isHidden = true
            dateLabel.isHidden = true
            diningLabel.isHidden = true
            pickerView.isHidden = true
            datePicker.isHidden = true
            SearchOne.isHidden = false
            SearchTwo.isHidden = false
            SearchThree.isHidden = false
            SearchFour.isHidden = false
            okButton.isHidden = true
            andLabel.isHidden = true
            stepLabel.text! = "Select Price Levels by which to Search"

        }
        if stepValue == 4
        {
            eventNameField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            orLabel.isHidden = true
            myLocationIconButton.isHidden = true
            dateLabel.isHidden = true
            diningLabel.isHidden = true
            pickerView.isHidden = true
            datePicker.isHidden = true
            SearchOne.isHidden = true
            SearchTwo.isHidden = true
            SearchThree.isHidden = true
            SearchFour.isHidden = true
            okButton.isHidden = false
            nextStep.isHidden = true
            andLabel.isHidden = true
            stepLabel.text! = "Get Ready to Swipe"
        }
        stepValue = stepValue + 1
    }
    

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
        self.dismissKeyboard()
        eventNameField.isHidden = false
        cityField.isHidden = true
        stateField.isHidden = true
        orLabel.isHidden = true
        myLocationIconButton.isHidden = true
        dateLabel.isHidden = true
        diningLabel.isHidden = true
        pickerView.isHidden = true
        datePicker.isHidden = true
        SearchOne.isHidden = true
        SearchTwo.isHidden = true
        SearchThree.isHidden = true
        SearchFour.isHidden = true
        okButton.isHidden = true
        andLabel.isHidden = true
        stepLabel.text! = "Give Your Event a Name"
        
//LocationManager Stuff
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
       
//Picker Views setup
        
        pickerView.isHidden = true
        datePicker.isHidden = true
        view.addSubview(pickerView)
        view.addSubview(datePicker)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(gestureRecognizer:)))
        let tap2 = UITapGestureRecognizer(target: self
            , action: #selector(self.tap2(gestureRecognizer:)))
        diningLabel.addGestureRecognizer(tap)
        dateLabel.addGestureRecognizer(tap2)
        
        //Label and Field Setup
        
        diningLabel.textColor = UIColor.gray
        dateLabel.textColor = UIColor.gray
        cityField.textColor = UIColor.black
        stateField.textColor = UIColor.black
        eventNameField.textColor = UIColor.black
        diningLabel.isUserInteractionEnabled = true
        dateLabel.isUserInteractionEnabled = true
        datePicker.backgroundColor = hexStringToUIColor(hex: "#46B1AA")
        dateLabel.layer.cornerRadius = 5
        dateLabel.clipsToBounds = true
        diningLabel.layer.cornerRadius = 5
        diningLabel.clipsToBounds = true
        okButton.layer.cornerRadius = 7
        
        //Dollar Sign Button Setup
        
        SearchOne.layer.cornerRadius = 5
        SearchOne.clipsToBounds = true
        SearchOne.backgroundColor = .white
        SearchTwo.layer.cornerRadius = 5
        SearchTwo.clipsToBounds = true
        SearchTwo.backgroundColor = .white
        SearchThree.layer.cornerRadius = 5
        SearchThree.clipsToBounds = true
        SearchThree.backgroundColor = .white
        SearchFour.layer.cornerRadius = 5
        SearchFour.clipsToBounds = true
        SearchFour.backgroundColor = .white
        
     
    }
    
    @IBAction func amendSearchOne(_ sender: UIButton) {
        DataManager.sharedData.addRemoveValue(dollarSignValue: 1)
        if SearchOne.backgroundColor == .gray{
        SearchOne.backgroundColor = .white
        }
        else
        {
        SearchOne.backgroundColor = .gray
        }

    }
    
    @IBAction func amendSearchTwo(_ sender: UIButton) {
       DataManager.sharedData.addRemoveValue(dollarSignValue: 2)
        if SearchTwo.backgroundColor == .gray{
            SearchTwo.backgroundColor = .white
        }
        else
        {
            SearchTwo.backgroundColor = .gray
        }
    }
    
    @IBAction func amendSearchThree(_ sender: UIButton) {
        DataManager.sharedData.addRemoveValue(dollarSignValue: 3)
        if SearchThree.backgroundColor == .gray{
            SearchThree.backgroundColor = .white
        }
        else
        {
            SearchThree.backgroundColor = .gray
        }
    }
    
    @IBAction func amendSearchFour(_ sender: UIButton) {
        DataManager.sharedData.addRemoveValue(dollarSignValue: 4)
        if SearchFour.backgroundColor == .gray{
            SearchFour.backgroundColor = .white
        }
        else
        {
            SearchFour.backgroundColor = .gray
        }
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
    }
    
//sets current location to the last known location coordinate stored
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if flag {
            currentLocation = locations.last?.coordinate
            DataManager.sharedData.myCurrentLocation = currentLocation
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
        diningLabel.textColor = UIColor.black
        pickerView.isHidden = false
        datePicker.isHidden = true
        cityField.resignFirstResponder()
        }

//When the date label is selected, show date scroll and hide type scroll
    
    func tap2(gestureRecognizer: UITapGestureRecognizer) {
        self.dismissKeyboard()
        self.hideKeyboard()
        dateLabel.textColor = UIColor.black
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
        diningLabel.text = DataManager.sharedData.venueType
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
