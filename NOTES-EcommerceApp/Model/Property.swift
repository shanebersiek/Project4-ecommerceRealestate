//
//  Property.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/29/17.
//  Copyright © 2017 saif. All rights reserved.
//

import Foundation
import UIKit


///without this line backendless wont be able to store this property
@objcMembers
class Property: NSObject {
    // for ints and bool backandless requires they have standard properties by default
    var objectId: String?
    var referenceCode: String?
    var ownerId: String?
    var title: String?
    var numberOfRooms: Int = 0
    var numberOfBathrooms: Int = 0
    var size: Double = 0.0
    var balconeySize: Double = 0.0
    var parking: Int = 0
    var floor: Int = 0
    var address: String?
    var city: String?
    var country: String?
    var propertyDescription: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var advertismentType: String?
    var availableFrom: String?
    var imageLinks: String? //should be text in backendless, string is too short
    var buildYear: String?
    var price: Int = 0
    var propertyType: String?
    var titleDeeds: Bool = false
    var centralHeating: Bool = false
    var solarWaterHeating: Bool = false
    var airConditioner: Bool = false
    var storeRoom: Bool = false
    var isFurnished: Bool = false
    var isSold: Bool = false
    var inTopUntil: Date?
    
    
    //MARK: -save functions
   
    func saveProperty(){
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore!.save(self)
        }
    
    
    func saveProperty(completetion: @escaping (_ value: String)-> Void) {
      
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore?.save(self, response: { (result) in
            
            completetion("Succes")
            
        }, error: { (fault: Fault?) in
            completetion(fault!.message)
        })
    }
    
    //MARK: Delete Functions
    
    func deleteProperty(property: Property){
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore!.remove(property)
        }
    
    func deleteProperty(property: Property, completetion: @escaping (_ value: String)-> Void){
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore!.remove(property, response: { (result) in
            completetion("success")
            
        }) { (fault: Fault?) in
            
            completetion(fault!.message)
        }
    }
    
    //MARK: Search Function
    
    class func fetchRecentProperties(limitNumber: Int, completion: @escaping (_ properties: [Property?])-> Void ){
        //inTopUntil
        let quiryBuilder = DataQueryBuilder()
        //choosing to sort by my inTopUntil variable and i can choose accending or decending
        quiryBuilder!.setSortBy(["inTopUntil DESC"])
        quiryBuilder!.setPageSize(Int32(limitNumber))
        quiryBuilder!.setOffset(0)
        
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore!.find(quiryBuilder, response: { (backendlessProperties) in
            
            completion(backendlessProperties as! [Property])
            
        }) { (fault: Fault?) in
            print("error could get recent properties \(fault!.message)")
            completion([])
        }
    }
    
    class func fetchAllProperties(completion: @escaping (_ _properties: [Property?])-> Void){
         let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore!.find({ (allProperties) in
            
            completion(allProperties as! [Property])
       
        }) { (fault: Fault?) in
            print("error could get recent properties \(fault!.message)")
            completion([])
        }
    }
    
    class func fetchPropertiesWith(whereClause: String, completion: @escaping (_ _properties: [Property?])-> Void) {
       
        let quiryBuilder = DataQueryBuilder()
        //choosing to sort by my inTopUntil variable and i can choose accending or decending
        quiryBuilder!.setSortBy(["inTopUntil DESC"])
        quiryBuilder!.setWhereClause(whereClause)
        
        let dataStore = backEndless!.data.of(Property().ofClass())
        dataStore?.find(quiryBuilder, response: { (allProperties) in
            completion(allProperties as! [Property])
            
        }, error: { (fault: Fault?) in
            print("error could get recent properties \(fault!.message)")
            completion([])
        })
    }
    
    
    
    
    
    
    
    
}//end of class
