//
//  AddPropertyViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class AddPropertyViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
    }
   
    @IBAction func mapPinButtonPressed(_ sender: Any) {
    }
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
    }
    
    
    //MARK: helper functions
    
   func save(){
        
        if titleTxtField.text != "" && referenceCodeTxtField.text != "" && advertismentTypeTxtField.text != "" && propertyTypeTxtField.text != "" && priceTxtField.text != ""{
            
            //create new property
            var newProperty = Property()
            
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
            
            
            newProperty.titleDeeds = titleDeedsSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.solarWaterHeating = solarHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.storeRoom = storeRoomSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            
            //check for property images
            
            newProperty.saveProperty()
            ProgressHUD.showSuccess("saved!")
            
        } else {
            
            ProgressHUD.showError("Error missing required txt fields!")
        }
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
    
    
    
    
    
}//end of class
