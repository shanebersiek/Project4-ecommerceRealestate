//
//  FUser.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/9/17.
//  Copyright © 2017 saif. All rights reserved.
//

import Foundation
import Firebase


class FUser {
    
    let objectID: String
    var pushID: String?
    
    var createdAt: Date
    var updatedAt: Date
    
    var isAgent: Bool
    
    var coins: Int
    var company: String
    var firstName: String
    var lastName: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var additionalPhoneNumber: String
    var favoriteProperties: [String]
    
    init(_objectID: String, _pushID: String?, _createdAT: Date, _updatedAt: Date, _firstName: String, _lastName: String, _avatar: String = "" , _phoneNumber: String = "") {
        
        objectID = _objectID
        pushID = _pushID
        
        
        createdAt = _createdAT
        updatedAt = _updatedAt
        
        coins = 10
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        avatar = _avatar
        isAgent = false
        company = ""
        favoriteProperties = []
        
        phoneNumber = _phoneNumber
        additionalPhoneNumber = ""
    }
    
    init(_Dictionary: NSDictionary) {
        
        objectID = _Dictionary[kOBJECTID] as! String
        pushID =  _Dictionary[kPUSHID] as? String
        
        
        if let created = _Dictionary[kCREATEDAT] {
            createdAt = dateFormatter().date(from: created as! String)!
        } else {
            createdAt = Date()
        }
        
        if let updated = _Dictionary[kUPDATEDAT] {
            updatedAt = dateFormatter().date(from: updated as! String)!
        } else {
            updatedAt = Date()
        }
        
        if let dCoin = _Dictionary[kCOINS] {
            coins = dCoin as! Int
        } else {
            coins = 0
        }
        
        if let fName = _Dictionary[kFIRSTNAME] {
            firstName = fName as! String
        } else {
            firstName = ""
        }
        
        if let lName = _Dictionary[kLASTNAME] {
            lastName = lName as! String
        } else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let avat = _Dictionary[kAVATAR] {
            avatar = avat as! String
        } else {
            avatar = ""
        }
        
        if let agent = _Dictionary[kISAGENT] {
            isAgent = agent as! Bool
        } else {
            isAgent = false
        }
        
        if let companeyName = _Dictionary[kCOMPANY] {
            company = companeyName as! String
        } else {
            company = ""
        }
        
        if let favorites = _Dictionary[kFAVORIT] {
            favoriteProperties = favorites as! [String]
        } else {
            favoriteProperties = []
        }
        
        if let phone = _Dictionary[kPHONE] {
            phoneNumber = phone as! String
        } else {
            phoneNumber = ""
        }
        
        if let addPhoneNumber = _Dictionary[kADDPHONE] {
            additionalPhoneNumber = addPhoneNumber as! String
        } else {
            additionalPhoneNumber = ""
        }
    }
    
    ///gets the current user id
    class func currentId() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    //returns our current logged in user from our stored default data
    class func currentUser() -> FUser? {
        //checks if we have a current user
        if Auth.auth().currentUser != nil {
            //pulls user from default device memmory
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return FUser(_Dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //registure user with email then saves them localy and to database
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?)-> Void) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (firuser, error) in
            if error != nil {
                completion(error)
                print("error saving user")
                return
            }
            // created a fUser object
            let fUser = FUser(_objectID: (firuser?.uid)!, _pushID: "", _createdAT: Date(), _updatedAt: Date(), _firstName: firstName, _lastName: lastName)
            print("user being saved")
            //save to user defaults
            saveUserLocaly(fUser: fUser)
            //save user to firebase
            saveUserInBackground(fuser: fUser)
            
            completion(error)
        }
    }
    
    ///register user with phone number
    class func registerUserWith(phoneNumber: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogIn: Bool)-> Void) {
    
        //access the value from default storage
        let verificationId = UserDefaults.standard.value(forKey: kVERIFICATIONCODE)
       
        //acceses the value from firebase
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId as! String, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credentials) { (firUser, error) in
            
            if error != nil {
                completion(error!, false)
                return
            }
           
            //fetches the user from the database
            fetchUserWith(userId: (firUser?.uid)!, completion: { (user) in
                
                ///check if user is logged in else register new user
                if user != nil && user!.firstName != "" {
                    
                    //we have a user with that object ID, log in!
                    saveUserLocaly(fUser: user!)
                    completion(error, true)
                } else {
                   
                    //we have no user with that id, register user to data base
                    let fUser = FUser(_objectID: (firUser?.uid)!, _pushID: "", _createdAT: Date(), _updatedAt: Date(), _firstName: "", _lastName: "", _avatar: "", _phoneNumber: (firUser?.phoneNumber)!)
                   
                    saveUserLocaly(fUser: fUser)
                    saveUserInBackground(fuser: fUser)
                    completion(error, false)
                }
            })
            
        
        }
        
    }
    
   
} //End of Class




//MARK: save user to firebase (background)
func saveUserInBackground(fuser: FUser){
    
    //creates user section and and section of users
    let ref = fireBaseData.child(kUSER).child(fuser.objectID)
    ref.setValue(userDictionaryFromUser(user: fuser))
}

//MARK: save user localy using default
func saveUserLocaly(fUser: FUser){
    print("saved locally")
    UserDefaults.standard.set(userDictionaryFromUser(user: fUser), forKey: kCURRENTUSER)
    print("my user model \(fUser.fullName)")
    UserDefaults.standard.synchronize()
    print("user that was saved :\(UserDefaults.standard.object(forKey: kCURRENTUSER))")
}


//MARK: helper functions

//this will take our class object and turn it into a Dictionary so we can add it to firebase or localy
func userDictionaryFromUser(user: FUser) -> NSDictionary {
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectID, createdAt, updatedAt, user.company, user.pushID!, user.firstName, user.lastName, user.fullName, user.avatar, user.phoneNumber, user.additionalPhoneNumber, user.isAgent, user.coins, user.favoriteProperties], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kCOMPANY as NSCopying, kPUSHID as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kPHONE as NSCopying, kADDPHONE as NSCopying, kISAGENT as NSCopying, kCOINS as NSCopying, kFAVORIT as NSCopying  ])
}

                                 //                  @escpaing is running on back ground thread
func updateCurrentUser(withValues: [String: Any], withBlock: @escaping (_ succes: Bool)-> Void){
    
    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
        print("checked")
        //geting the user object that was locally stored
        let currentUser = FUser.currentUser()!
        //converting it to a NSDictionary
        let userObject = userDictionaryFromUser(user: currentUser).mutableCopy() as! NSMutableDictionary
        //? (maybe updating the values)
        userObject.setValuesForKeys(withValues)
      
        // update in fire base
        let ref = fireBaseData.child(kUSER).child(currentUser.objectID)
        ref.updateChildValues(withValues, withCompletionBlock: { (error, ref) in
           
            if error != nil {
                withBlock(false)
                return
            }
            //update localy
            UserDefaults.standard.set(userObject, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            withBlock(true)
        })
    }; print("\(UserDefaults.standard.array(forKey: kCURRENTUSER))")
}



//fetches the user from the database
func fetchUserWith(userId: String, completion: @escaping (_ user: FUser?) -> Void){
 
    let userRef = fireBaseData.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId)
    // listener
    userRef.observeSingleEvent(of: .value) { (snapShot) in
        
        if snapShot.exists() {
        let userDictionary = ((snapShot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary
            
            let user = FUser(_Dictionary: userDictionary)
            
            //complitions run A-sync
            completion(user)
            
        }
        else {
            completion(nil)
            
        }
    }
}


//MARK: OneSignal

func updateOneSignalId() {
    
    if FUser.currentUser() != nil {
        
        if let pushId = UserDefaults.standard.string(forKey: "OneSignalId"){
            //set one signal id
            setOneSignalId(pushId: pushId)
        } else {
            //remove one signal Id
            removeOneSignalId()
        }
    }
    
}

func setOneSignalId(pushId: String) {
    updateCurrentUserOneSignalId(newId: pushId)
}

func removeOneSignalId(){
    updateCurrentUserOneSignalId(newId: "")
}

func updateCurrentUserOneSignalId(newId: String){
   
    updateCurrentUser(withValues: [kPUSHID : newId, kUPDATEDAT: dateFormatter().string(from: Date())]) { (success) in
        
        print("one signal Id was updated - \(success)")
    }
}



















