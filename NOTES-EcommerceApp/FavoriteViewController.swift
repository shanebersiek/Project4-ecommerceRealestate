//
//  FavoriteViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 12/6/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    
    
//    override func viewWillLayoutSubviews() {
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProperties()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//       collectionView.register(PropertyCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
    }

  
    //MARK: CollectionViewDataSource

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! PropertyCollectionViewCell
        
        cell.delegate = self
        cell.generateCell(property: properties[indexPath.row])
        
        return cell
    }
    
    
    //MARK: -collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
        
        propertyVC.property = properties[indexPath.row]
        
        self.present(propertyVC, animated: true, completion: nil)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
    }
    
    
    // load properties
    
    func loadProperties(){
        
        self.properties = []
        
        let user = FUser.currentUser()!
        
        let stringArray = user.favoriteProperties
        ///takes an array of strings and converts it into a single string
        let string = "'" + stringArray.joined(separator: "', '") + "'"
        print("special string \(string)")
        
        if user.favoriteProperties.count > 0 {
            
            let whereClause = "objectId IN (\(string))"
            print("special string \(whereClause)")
            Property.fetchPropertiesWith(whereClause: whereClause, completion: { (allProperties) in
               
                if allProperties.count != 0 {
                    
                    self.properties = allProperties as! [Property]
                    
                   print("biggest slut \(self.properties[0])")
                    self.collectionView.reloadData()
                }
            })
        } else {
            self.collectionView.reloadData()
        }
    }
    
    
    
}
