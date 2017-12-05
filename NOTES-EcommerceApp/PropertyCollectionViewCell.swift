//
//  PropertyCollectionViewCell.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

@objc protocol PropertyCollectionViewCellDelegate {
    
    @objc optional func didClickStarButton(property: Property)
    @objc optional func didClickMenuButton(property: Property)
}

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
    
    var delegate: PropertyCollectionViewCellDelegate?
    
    var property: Property!
    
    //so i can set the properties in my cell cleaner
    func generateCell(property: Property){
        
        ///made a variable in the cell so can pass the data object i get back into, and use the data in this cell
        self.property = property
        
        guard let title = property.title else {return}
        propertyTitleLabel.text = title
        roomLabel.text = "\(property.numberOfRooms)"
        bathroomLabel.text = "\(property.numberOfBathrooms)"
        parkingLabel.text = "\(property.parking)"
        priceLabel.text = "\(property.price)"
        priceLabel.sizeToFit()
        
        //topAdd
        if property.inTopUntil != nil && property.inTopUntil! > Date(){
            topAddImageView.isHidden = false
        } else {
            topAddImageView.isHidden = true 
        }
       
        //liked property
        if self.likeButtonOutlet != nil {
            
            if FUser.currentUser() != nil && FUser.currentUser()!.favoriteProperties.contains(property.objectId!){
                self.likeButtonOutlet.setImage(#imageLiteral(resourceName: "starFilled"), for: .normal)
            } else {
                
                self.likeButtonOutlet.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            }
            
            
        }
        
        //sold
        if property.isSold{
            soldImageView.isHidden = false
        } else {
            soldImageView.isHidden = true
        }
        
        //image
        if property.imageLinks != "" && property.imageLinks != nil {
            
            //download images
            downloadImages(urls: property.imageLinks!, withBlock: { (images) in
                
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.imageView.image = images.first!
                
            })
            
        } else {
            self.imageView.image = #imageLiteral(resourceName: "propertyPlaceholder")
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
        
    }
    
    //MARK: IB ACTIONS
    
    @IBAction func starButtonPressed(_ sender: Any) {
        print("star button print")
        delegate!.didClickStarButton!(property: property)
    }
    
}//End Of Class
