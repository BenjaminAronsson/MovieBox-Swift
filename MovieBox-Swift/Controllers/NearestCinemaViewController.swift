//
//  NearestCinemaViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-21.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import MapKit

class NearestCinemaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            
        }
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
                
                let locValue:CLLocationCoordinate2D = manager.location!.coordinate
                
                mapView.mapType = MKMapType.standard
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = locValue
                annotation.title = "Movie lover"
                annotation.subtitle = "current location"
                mapView.addAnnotation(annotation)
            }
        }
    }

    
}
