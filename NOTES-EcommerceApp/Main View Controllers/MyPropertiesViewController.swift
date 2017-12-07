//
//  MyPropertiesViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 12/7/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class MyPropertiesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate {

  
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !isUserIsLoggedIn(viewController: self) {
            return
        } else {
            loadProperties()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

   
    //MARK: -collection view data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
   

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! PropertyCollectionViewCell
        
        cell.delegate = self
        cell.generateCell(property: properties[indexPath.row])
        
        return cell
    }

    //MARK; collectionVIEW DELEGATE FUNCS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
        
        propertyVC.property = properties[indexPath.row]
        
        self.present(propertyVC, animated: true, completion: nil)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
    }

    //MARK: LoadProperties
    
    func loadProperties(){
        let userId = FUser.currentId()
        let whereClause = "ownerId = '\(userId)'"
        Property.fetchPropertiesWith(whereClause: whereClause) { (allProperties) in
            self.properties = allProperties as! [Property]
            self.collectionView.reloadData()
        }
    }
    
    
     //MARK: PropertyCollectionVIewDelegate
    
    func didClickMenuButton(property: Property) {
        
        let soldeStatus = property.isSold ? "Mark Available" : "Mark Sold"
        var topStatus = "Promote"
        var isInTop = false
        
        if property.inTopUntil != nil && property.inTopUntil! > Date() {
            isInTop = true
            topStatus = "Already in top"
        }
        
        let optionMenue = UIAlertController(title: "Property Menu", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit Property", style: .default) { (alert) in
            print("eddit action")
        }
        let makeTopAction = UIAlertAction(title: topStatus, style: .default) { (alert) in
            print("make Top")
        }
        
        let soldAction = UIAlertAction(title: soldeStatus, style: .default) { (action) in
            property.isSold = !property.isSold
            property.saveProperty()
            self.loadProperties()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            ProgressHUD.show("Deleting...")
            property.deleteProperty(property: property, completetion: { (message) in
                ProgressHUD.showSuccess("Deleted!")
                self.loadProperties()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        optionMenue.addAction(editAction)
        optionMenue.addAction(makeTopAction)
        optionMenue.addAction(soldAction)
        optionMenue.addAction(deleteAction)
        optionMenue.addAction(cancelAction)
        
        self.present(optionMenue, animated: true, completion: nil)
        
    }
   
    
  
    
    

}//ENd of Class

