//
//  MapViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 12/4/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit
import MapKit


protocol MKMapViewDelegate {
    
    func didFinishWith(coordinate: CLLocationCoordinate2D)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

   
    
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: MKMapViewDelegate?
    var pinCoordinates: CLLocationCoordinate2D? 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTouch))
        
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
 
        ///can set region were drop pin map opens up to
//        var region = MKCoordinateRegion()
//
//        region.center.latitude = 4
//        region.center.longitude = 3
//        region.span.latitudeDelta = 500
//        region.span.longitudeDelta = 500
//        mapView.setRegion(region, animated: true)
    }

    
    
    //MARK: -IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    
        if mapView.annotations.count == 1 && pinCoordinates != nil {
            
            delegate!.didFinishWith(coordinate: pinCoordinates!)
            self.dismiss(animated: true, completion: nil)
        
        } else {
           
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
   
    @IBAction func cancleButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: -helper functions
    
    @objc func handleLongTouch(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began {
            
            let location = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            
            //drop a pin
            dropPin(coordinate: coordinates)
        }
    }
    
    
    
    func dropPin(coordinate: CLLocationCoordinate2D){
        
        //remove all exsisting pins from the map
        mapView.removeAnnotations(mapView.annotations)
        //update global var
        pinCoordinates = coordinate
        
        //drops pin in map view 
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
    
    
    
   
    
    
    

}//End of Class
