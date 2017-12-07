//
//  AddPropertyViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit
import ImagePicker

class AddPropertyViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, ImagePickerDelegate {
   
    var yearArray: [Int] = []
    
    var datePicker = UIDatePicker()
    //pickers
    var propertyTypePicker = UIPickerView()
    var advertismentTypePicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    var locationMannager: CLLocationManager?
    var locationCoordinates: CLLocationCoordinate2D?
    
    var activeField: UITextField?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    //MARK: IBOutlets
    
    @IBOutlet weak var referenceCodeTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var roomsTxtField: UITextField!
    @IBOutlet weak var bathroomsTxtField: UITextField!
    @IBOutlet weak var propertySizeTxtField: UITextField!
    @IBOutlet weak var balconySizeTxtField: UITextField!
    @IBOutlet weak var parkingTxtField: UITextField!
    @IBOutlet weak var floorTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var advertismentTypeTxtField: UITextField!
    @IBOutlet weak var availableFromTxtField: UITextField!
    @IBOutlet weak var buildYearTxtField: UITextField!
    @IBOutlet weak var propertyTypeTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    //switches
    @IBOutlet weak var titleDeedsSwitch: UISwitch!
    @IBOutlet weak var centralHeatingSwitch: UISwitch!
    @IBOutlet weak var solarHeatingSwitch: UISwitch!
    @IBOutlet weak var storeRoomSwitch: UISwitch!
    @IBOutlet weak var airConditionerSwitch: UISwitch!
    @IBOutlet weak var furnishedSwitch: UISwitch!
    
    var user: FUser?
    var titleDeedsSwitchValue = false
    var centralHeatingSwitchValue = false
    var solarHeatingSwitchValue = false
    var storeRoomSwitchValue = false
    var airConditionerSwitchValue = false
    var furnishedSwitchValue = false
    
    var propertyImages: [UIImage] = []
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManagerStop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
       
       
        referenceCodeTxtField.delegate = self
        titleTxtField.delegate = self
        roomsTxtField.delegate = self
        bathroomsTxtField.delegate = self
        propertySizeTxtField.delegate = self
        balconySizeTxtField.delegate = self
        parkingTxtField.delegate = self
        floorTxtField.delegate = self
        addressTxtField.delegate = self
        cityTxtField.delegate = self
        countryTxtField.delegate = self
        advertismentTypeTxtField.delegate = self
        availableFromTxtField.delegate = self
        buildYearTxtField.delegate = self
        propertyTypeTxtField.delegate = self
        priceTxtField.delegate = self
        
        setupYearArray()
        setUpPickers()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
       scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.size.height)
        
    }

    //MARK: -IBActions
    @IBAction func saveButtonPressed(_ sender: Any) {
        user = FUser.currentUser()!
        save()
        if !user!.isAgent {
          //check if user can post
        } else {
            save()
        }
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
    let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMAGENUMBER
        
        present(imagePickerController, animated: true, completion: nil)
    
    }
   
    @IBAction func mapPinButtonPressed(_ sender: Any) {
        //show map so the user can set location
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapView.delegate = self
        
        self.present(mapView, animated: true, completion: nil)
    }
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        
        locationManagerStart()
    }
    
    
    //MARK: helper functions
    
    func setupYearArray(){
       
        for i in 1800...2003{
            yearArray.append(i)
        }
        yearArray.reverse()
    }
    
    
    
    
   func save(){
        
        if titleTxtField.text != "" && referenceCodeTxtField.text != "" && advertismentTypeTxtField.text != "" && propertyTypeTxtField.text != "" && priceTxtField.text != ""{
            
            //create new property
            var newProperty = Property()
            
            ProgressHUD.show("Saving...")
            
            newProperty.referenceCode = referenceCodeTxtField.text!
            newProperty.ownerId = user!.objectID
            newProperty.title = titleTxtField.text!
            newProperty.advertismentType = advertismentTypeTxtField.text!
            newProperty.price = Int(priceTxtField.text!)!
            newProperty.propertyType = propertyTypeTxtField.text
            
            if balconySizeTxtField.text != "" {
                newProperty.balconeySize = Double(balconySizeTxtField.text!)!
            }
            if propertySizeTxtField.text != "" {
                newProperty.size = Double(propertySizeTxtField.text!)!
            }
            if bathroomsTxtField.text != "" {
                newProperty.numberOfBathrooms = Int(bathroomsTxtField.text!)!
            }
            if roomsTxtField.text != "" {
                newProperty.numberOfRooms = Int(roomsTxtField.text!)!
            }
            if parkingTxtField.text != "" {
                newProperty.parking = Int(parkingTxtField.text!)!
            }
            if floorTxtField.text != "" {
                newProperty.floor = Int(floorTxtField.text!)!
            }
            if addressTxtField.text != "" {
                newProperty.address = addressTxtField.text
            }
            if cityTxtField.text != "" {
                newProperty.city = cityTxtField.text
            }
            if countryTxtField.text != "" {
                newProperty.country = countryTxtField.text
            }
            if availableFromTxtField.text != "" {
                newProperty.availableFrom = availableFromTxtField.text
            }
            if buildYearTxtField.text != "" {
                newProperty.buildYear = buildYearTxtField.text
            }
            if descriptionTxtView.text != "" && descriptionTxtView.text != "Description" {
                newProperty.propertyDescription = descriptionTxtView.text
            }
            if locationCoordinates != nil {
                newProperty.latitude = locationCoordinates!.latitude
                newProperty.longitude = locationCoordinates!.longitude
            }
            
            newProperty.titleDeeds = titleDeedsSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.solarWaterHeating = solarHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.storeRoom = storeRoomSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            
            //check for property images
            if propertyImages.count != 0 {
                
                print("uploading")
                uploadImages(images: propertyImages, userId: (user?.objectID)!, referanceNumber: newProperty.referenceCode!, withBlock: { (linkString) in
                    newProperty.imageLinks = linkString
                    newProperty.saveProperty()
                    ProgressHUD.showSuccess("saved!")
                    self.dismissView()
                })
                
            } else {
                newProperty.saveProperty()
                ProgressHUD.showSuccess("saved!")
                self.dismissView()
            }
            
            
            
        } else {
            
            ProgressHUD.showError("Error missing required txt fields!")
        }
    }
    
    func dismissView(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    //switches
    @IBAction func titleDeedSwitched(_ sender: Any) {
        ///makes it equal to the opposit of what it is
        titleDeedsSwitchValue = !titleDeedsSwitchValue
    }
    @IBAction func centralHeatingSwitched(_ sender: Any) {
        centralHeatingSwitchValue = !centralHeatingSwitchValue
    }
    @IBAction func solarHeatingSwitched(_ sender: Any) {
        solarHeatingSwitchValue = !solarHeatingSwitchValue
    }
    @IBAction func storeRoomSwitched(_ sender: Any) {
        storeRoomSwitchValue = !storeRoomSwitchValue
    }
    @IBAction func airConditionerSwitched(_ sender: Any) {
        airConditionerSwitchValue = !airConditionerSwitchValue
    }
    @IBAction func furnishedSwitched(_ sender: Any) {
        furnishedSwitchValue = !furnishedSwitchValue
    }
    
    //MARK: -Image Picker Delegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper")
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        propertyImages = images
        print("number of images \(propertyImages.count)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -picker view
    
    
    func setUpPickers() {
        
        yearPicker.delegate = self
        propertyTypePicker.delegate = self
        advertismentTypePicker.delegate = self
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let DoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        
        toolBar.setItems([flexibleBar, DoneButton], animated: true)
        
        buildYearTxtField.inputAccessoryView = toolBar
        buildYearTxtField.inputView = yearPicker
        
        availableFromTxtField.inputAccessoryView = toolBar
        availableFromTxtField.inputView = datePicker
        
        propertyTypeTxtField.inputAccessoryView = toolBar
        propertyTypeTxtField.inputView = propertyTypePicker
        
        advertismentTypeTxtField.inputAccessoryView = toolBar
        advertismentTypeTxtField.inputView = advertismentTypePicker
    }
    
    @objc func doneButtonPressed(){
        
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == propertyTypePicker{
           return propertyTypes.count
        }
        
        if pickerView == advertismentTypePicker{
            return advertismentTypes.count
        }
        
        if pickerView == yearPicker{
            return yearArray.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == propertyTypePicker{
            return propertyTypes[row]
        }
        
        if pickerView == advertismentTypePicker{
            return advertismentTypes[row]
        }
        
        if pickerView == yearPicker{
            return "\(yearArray[row])"
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        var rowValue = row
        
        if pickerView == propertyTypePicker{
            
            if rowValue == 0 { rowValue = 1 }
            propertyTypeTxtField.text = propertyTypes[rowValue]
        }
        
        if pickerView == advertismentTypePicker{
             if rowValue == 0 { rowValue = 1 }
            advertismentTypeTxtField.text = advertismentTypes[rowValue]
        }
        
        if pickerView == yearPicker{
            buildYearTxtField.text = "\(yearArray[row])"
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        
        
        if activeField == availableFromTxtField {
            availableFromTxtField.text = "\(components.month!)/\(components.day!)/\(components.year!)"
        }
        
    }
    
    //MARK: UITextField delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    //MARK: -Location manager del functions
    
    func locationManagerStart(){
        if locationMannager == nil {
            locationMannager = CLLocationManager()
            locationMannager!.delegate = self
            locationMannager!.desiredAccuracy = kCLLocationAccuracyBest
            locationMannager!.requestWhenInUseAuthorization()
        }
        
        locationMannager!.startUpdatingLocation()
    }
    
    func locationManagerStop(){
        
        if locationMannager != nil {
            locationMannager?.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status  {
        case .notDetermined: manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse: manager.startUpdatingLocation()
            break
        case .authorizedAlways: manager.startUpdatingLocation()
            break
        case .restricted: //would be a case for like parental control
            break
        case .denied: locationMannager = nil
            print("location Denied")
            //good place to show user notification to enable location from settings
        ProgressHUD.showError("Please enable location from settings")
            break
       
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationCoordinates = locations.last!.coordinate
        
    }
    
    //MARK: -MAPVIEWDELEGATES
    
    func didFinishWith(coordinate: CLLocationCoordinate2D) {
        
        locationCoordinates = coordinate
        print("coordinate = \(coordinate)")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    
}//end of class
