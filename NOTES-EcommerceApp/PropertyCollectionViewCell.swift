//
//  PropertyCollectionViewCell.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class PropertyCollectionViewCell: UICollectionViewCell {
    //MARK: -IB Elements
   
    
    @IBOutlet weak var propertyTitleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topAddImageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    
    //so i can set the properties in my cell cleaner
    func generateCell(property: Property){
        
        guard let title = property.title else {return}
        propertyTitleLabel.text = title
        roomLabel.text = "\(property.numberOfRooms)"
        bathroomLabel.text = "\(property.numberOfBathrooms)"
        parkingLabel.text = "\(property.parking)"
        priceLabel.text = "\(property.price)"
        priceLabel.sizeToFit()
    }
    
    //MARK: IB ACTIONS
    
    @IBAction func starButtonPressed(_ sender: Any) {
    }
}
