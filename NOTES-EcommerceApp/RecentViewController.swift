//
//  RecentViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var collectionView: UICollectionView!
    
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
       
        
       // print("show the title value: \(properties[0].title)")
        
        ///sets my properties for the cell
        cell.generateCell(property: properties[indexPath.row])
//        cell.titleLabel.text = "hi"
        
        return cell
    }
    
    
    //MARK: collectionview delegate functions
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //show property
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
    }
    
}
