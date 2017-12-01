//
//  Settings.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/9/17.
//  Copyright © 2017 saif. All rights reserved.
//

import Foundation



//in NSdictionary you cant put a date object you have to convert it to string
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let myDateFormatter = DateFormatter()
    
    myDateFormatter.dateFormat = dateFormat
    
    return myDateFormatter
}
