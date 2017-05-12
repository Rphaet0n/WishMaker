//
//  MappinForExecutorViewController.swift
//  WishMaker
//
//  Created by maxik on 12.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MappinForExecutorViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    // For you Ahper jan
    
    var destinationCoordinate = CLLocationCoordinate2D()
    var destination =  MKMapItem()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        
        destinationCoordinate = CLLocationCoordinate2D(latitude: 47.21666, longitude: 39.62842)
        
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
        let region = MKCoordinateRegion(center: myPosition, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func showDirection(_ sender: Any) {
        
        let placeMark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        destination = MKMapItem(placemark: placeMark)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {
            (response: MKDirectionsResponse?, error: Error?) in
            
            if error != nil {
                print("Error \(error)")
            } else {
                
                let overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                for route in (response?.routes)! {
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                    
                    for next in route.steps {
                        print (next.instructions)
                    }
                }
            }
            
        })
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let draw = MKPolylineRenderer(overlay: overlay)
        draw.strokeColor = UIColor.purple
        draw.lineWidth = 3.0
        return draw
    }
    
}
