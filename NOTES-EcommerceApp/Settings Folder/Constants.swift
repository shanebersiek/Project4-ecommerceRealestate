//
//  Constants.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/9/17.
//  Copyright © 2017 saif. All rights reserved.
//

import Foundation
import Firebase

var backEndless = Backendless.sharedInstance()
var fireBaseData = Database.database().reference()

let propertyTypes = ["Select", "Appartment", "house", "villa", "Land", "Condo"]
let advertismentTypes = ["Select", "Sale", "Rent", "Exchange"]

//MARK: IDS AND KEYS
public let kONESIGNALID = "efcd12eb-9d4a-4c9c-9a04-98d52351f18c"
public let kFILEREFERENCE = "gs://note-ecommerceapp.appspot.com"

//F-User
public let kOBJECTID = "objectID"
public let kUSER = "User"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kCOMPANY = "company"
public let kPHONE = "phone"
public let kADDPHONE = "addPhone"

public let kCOINS = "coins"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstName"
public let kLASTNAME = "lastName"
public let kFULLNAME = "fullName"
public let kAVATAR = "avatar"
public let kCURRENTUSER = "currentUser"
public let kISONLINE = "isOnline"
public let kVERIFICATIONCODE = "firebase_verification"
public let kISAGENT = "isAgent"
public let kFAVORIT = "favoritProperties"

//Property
public let kMAXIMAGENUMBER = 10
public let kRECENTPROPERTYLIMIT = 20


//FBNotification
public let kFBNOTIFICATIONS = "Notifications"
public let kNOTIFICATIONID = "notificationId"
public let kPROPERTYREFERENCEID = "referenceId"
public let kPROPERTYOBJECTID = "propertyObjectId"
public let kBUYERFULLNAME = "buyerFullName"
public let kBUYERID = "buyerId"
public let kAGENTID = "agentId"


//push
public let kDEVICEID = "deviceId"
















