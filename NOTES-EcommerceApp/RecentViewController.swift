//
//  RecentViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate {
  
    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfPropertiesTextField: UITextField?
    
    var properties: [Property] = []
    
//    override func viewWillLayoutSubviews() {
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
//
    
    override func viewWillAppear(_ animated: Bool) {
       //load properties
        
        loadProperties(limitNumber: kRECENTPROPERTYLIMIT)
        print("test viewWill appear")
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.register(PropertyCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        }
    
    //MARK: collectionview data source functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! PropertyCollectionViewCell
       
        //sets the delegate
        cell.delegate = self
        ///sets my properties for the cell
        
        cell.generateCell(property: properties[indexPath.row])
//        cell.titleLabel.text = "hi"
        
        return cell
    }
    
    
    //MARK: collectionview delegate functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //show property
        let propertyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyView") as! PropertyViewController
        ///passes the property from my properties array on this page too my property var in propertiesViewController
        propertyView.property = properties[indexPath.row]
        self.present(propertyView, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
    }
    
    //MARK: Load properties
    
    func loadProperties(limitNumber: Int){
        Property.fetchRecentProperties(limitNumber: limitNumber) { (allProperties) in
            if allProperties.count != 0 {
               
                self.properties = allProperties as! [Property]
                print("test loadProperties number of properties: \(self.properties.count) the property object = \(self.properties) th property title = \(self.properties[0].title)")
                self.collectionView.reloadData()
                
            }
        }
    }
    
    
    //MARK: IB action
    @IBAction func mixerButtonpressed(_ sender: Any) {
       
        let alertcontroler = UIAlertController(title: "Update", message: "Set the number of properties to display", preferredStyle: .alert)
        
        
        alertcontroler.addTextField { (numberOfProperties) in
           
            numberOfProperties.placeholder = "Number Of Properties"
            numberOfProperties.borderStyle = .roundedRect
            numberOfProperties.keyboardType = .numberPad
            self.numberOfPropertiesTextField = numberOfProperties
            
        }
        let cancleAction = UIAlertAction(title: "cancle", style: .cancel) { (action) in
            
        }
        let updateAction = UIAlertAction(title: "update", style: .default) { (action) in
            
            if self.numberOfPropertiesTextField?.text != "" && self.numberOfPropertiesTextField?.text != "0" {
                
                ProgressHUD.show("Updating...")
                self.loadProperties(limitNumber: Int((self.numberOfPropertiesTextField?.text)!)!)
            }
        }
        
        alertcontroler.addAction(cancleAction)
        alertcontroler.addAction(updateAction)
        
        self.present(alertcontroler, animated: true, completion: nil)
    }
    
    //MARK: PropertyCollectionViewDelegate
    
    
    func didClickStarButton(property: Property) {
       
        
        
        //check if we have a user
        if FUser.currentUser() != nil {
            //save to favorites
        
            let user  = FUser.currentUser()!
            //check if the property is already in the users favorit properties
            if user.favoriteProperties.contains(property.objectId!){
                
                print("property contained")
                
                ///finds the index of the property im deleteing
                let index = user.favoriteProperties.index(of: property.objectId!)
                user.favoriteProperties.remove(at: index!)
                
                updateCurrentUser(withValues: [kFAVORIT : user.favoriteProperties], withBlock: { (success) in
                    
                    if !success {
                        print("error removing favorit")
                    } else {
                       
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Removed from list")
                    }
                })
                
            } else {
                //add to favorits list
              
                //add propertis to favorits array
                user.favoriteProperties.append(property.objectId!)
                
                //updates data in cloud
                updateCurrentUser(withValues: [kFAVORIT : user.favoriteProperties], withBlock: { (success) in
                
                    if !success {
                        print("error adding favorit")
                    } else {
                        
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Added to list!")
                    }
                })
                
            }
            
        
        } else {
            //show log in screen
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}//End Of Class
