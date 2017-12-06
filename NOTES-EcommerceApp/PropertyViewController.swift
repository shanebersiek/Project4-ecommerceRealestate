//
//  PropertyViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 12/6/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit
import MapKit


class PropertyViewController: UIViewController {
 
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shortInformationLabel: UILabel!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var furnishedLabel: UILabel!
    @IBOutlet weak var storeRoomLabel: UILabel!
    @IBOutlet weak var airConditionerLabel: UILabel!
    @IBOutlet weak var solarWaterHeatingLabel: UILabel!
    @IBOutlet weak var centralHeatingLabel: UILabel!
    @IBOutlet weak var titleDeedLabel: UILabel!
    @IBOutlet weak var constructionYearLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var balconeySizeLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var availableDateLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var callBackButtonOutlet: UIButton!
    
    var property: Property!
    var propertyCoordinates: CLLocationCoordinate2D?
    var imageArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPropertyImages()
        setupUI()
       
    }

    //MARK: IBAction
    
 
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callBackButtonPressed(_ sender: Any) {
    }
    
//    //MARK: -Helpers
    func getPropertyImages(){
        if property.imageLinks != "" && property.imageLinks != nil {
            
            downloadImages(urls: property.imageLinks!, withBlock: { (images) in
                self.imageArray = images as! [UIImage]
                self.setSlideShow()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            
        } else {
            //we have no images
            self.imageArray.append(#imageLiteral(resourceName: "propertyPlaceholder"))
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func setSlideShow(){
        
        for i in 0..<imageArray.count{
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
        }
        
    }
    
    func setupUI(){
        
        if FUser.currentUser() != nil {
            self.callBackButtonOutlet.isEnabled = true
            }
       // set properties
        
        titleLabel.text = property.title
        priceLabel.text = "\(property.price)"
        shortInformationLabel.text = "\(property.size) m2 - \(property.numberOfRooms) BedRoom(s)"
        propertyTypeLabel.text = property.propertyType
        furnishedLabel.text = property.isFurnished ? "yes" : "no"
        storeRoomLabel.text = property.storeRoom ? "yes" : "no"
        airConditionerLabel.text = property.airConditioner ? "yes" : "no"
        solarWaterHeatingLabel.text = property.solarWaterHeating ? "yes" : "no"
        centralHeatingLabel.text = property.centralHeating ? "yes" : "no"
        titleDeedLabel.text = property.titleDeeds ? "yes" : "no"
        
        constructionYearLabel.text = property.buildYear
        floorLabel.text = "\(property.floor)"
        parkingLabel.text = "\(property.parking)"
        bathroomLabel.text = "\(property.numberOfRooms)"
        balconeySizeLabel.text = "\(property.balconeySize)"
        availableDateLabel.text =  property.availableFrom
        
        //optional
        
        descriptionLabel.isHidden = true
        descriptionTextField.isHidden = true
        addressLabel.isHidden = true
        mapView.isHidden = true
        
        if property.propertyDescription != nil && property.propertyDescription != "Description:"  {
           
            descriptionLabel.isHidden = false
            descriptionTextField.isHidden = false
            descriptionTextField.text = property.propertyDescription
        }
        
        if property.address != nil && property.address != "" {
            addressLabel.isHidden = false
            addressLabel.text = property.address
        }
        
        if property.latitude != 0 && property.latitude != nil {
            
            mapView.isHidden = false
            propertyCoordinates = CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.title = property.title
            annotation.subtitle = "\(property.numberOfRooms) BedRoom \(property.propertyType!)"
            annotation.coordinate = propertyCoordinates!
            self.mapView.addAnnotation(annotation)
        }
           mainScrollView.contentSize = CGSize(width: view.frame.width, height: stackView.frame.size.height + 50)
    }
    
    

}//End of Class
