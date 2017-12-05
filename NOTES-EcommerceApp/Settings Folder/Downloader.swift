//
//  Downloader.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 12/4/17.
//  Copyright © 2017 saif. All rights reserved.
//

import Foundation
import Firebase



let storage = Storage.storage()

func downloadImages(urls: String, withBlock: @escaping (_ images: [UIImage?])-> Void){
    
    let linkArray = seperateImageLinks(allLinks: urls)
    var imageArray = [UIImage]()
    var downloadCounter = 0
    
    for link in linkArray{
        
        let url = NSURL(string: link)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf: url as! URL)
            
            if data != nil {
                
            let image = UIImage(data: data as! Data)
                
                imageArray.append(image!)
                
                if downloadCounter == imageArray.count {
                    DispatchQueue.main.async {
                        withBlock(imageArray)
                        
                    }
                }
            } else {
                print("coudnt Download Image")
                withBlock(imageArray)
            }
        }
    }
    
}

func uploadImages(images: [UIImage], userId: String, referanceNumber: String, withBlock: @escaping (_ imageLink: String?)-> Void){
    
    print("start uploading")
    convertImagesToData(images: images) { (pictures) in
          print("pics received \(pictures.count)")
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        
        for picture in pictures {
            
            //creates file name and path in fireBase
            let fileName = "PropertyImages/" + userId + "/" + referanceNumber + "/image" + "\(nameSuffix)" + ".jpg"
            
            nameSuffix += 1
            let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
            
            var task: StorageUploadTask!
           
            task = storageRef.putData(picture, metadata: nil, completion: { (metaData, error) in
                
                uploadCounter += 1
                
                if error != nil {
                    print("error uploading picture \(error?.localizedDescription)")
                    return
                }
                   let link = metaData?.downloadURL()
                linkString = linkString + link!.absoluteString + ","
                
                if uploadCounter == pictures.count {
                    
                    task.removeAllObservers()
                    withBlock(linkString)
                }
                
            })
        }
    }
    
}

// MARK: helper functions


func convertImagesToData(images: [UIImage], withBlock: @escaping (_ datas: [Data])-> Void){
    var dataArray: [Data] = []
    
    for image in images {
        //makes my images data
    let imageData = UIImageJPEGRepresentation(image, 0.5)!
        dataArray.append(imageData)
    }
    
    withBlock(dataArray)
}


func seperateImageLinks(allLinks: String)-> [String] {
   //seperates my links by commas
    var linkArray = allLinks.components(separatedBy: ",")
   //there is a comment at the end that adds an empty array i get rid of it here
    linkArray.removeLast()
    
    return linkArray
}

