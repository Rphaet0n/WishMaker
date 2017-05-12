//
//  MappingViewController.swift
//  WishMaker
//
//  Created by maxik on 12.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MappingForExecutorViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    // For you Ahper jan
    
    var destinationCoordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        
        destinationCoordinate = CLLocationCoordinate2D(latitude: 47.231754, longitude: 39.709593)
        
        annotation.coordinate = destinationCoordinate
        annotation.title = "HOME"
        annotation.subtitle = "Location of destination"
        self.mapView.addAnnotation(annotation)
        var allAnnotations = mapView.annotations
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        myPosition = locations[0].coordinate
        
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        //self.mapView.removeAnnotations(mapView.annotations)
        
        
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.mapView)
        
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord
        annotation.title = "Where"
        annotation.subtitle = "Location of destination"
        
        destinationCoordinate = locCoord
        
        print("\(destinationCoordinate.latitude) \(destinationCoordinate.longitude)" )
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        
    }
    
}
