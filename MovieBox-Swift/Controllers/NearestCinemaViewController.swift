//
//  NearestCinemaViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-21.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

class NearestCinemaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMapTrackingButton()
        
        mapView.delegate = self
        self.locationManager = CLLocationManager()
        
        if(authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
            //updating map
            self.mapView.showsUserLocation = true
            self.mapView.mapType = MKMapType(rawValue: 0)!
            self.mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
            locationManager.startUpdatingLocation()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingHeading()
            
            //findCinema()
            
            print("\(mapItemList)")
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    
    var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
                
                locValue = manager.location!.coordinate
                
                mapView.mapType = MKMapType.standard
                userCoordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
            }
        }
    }
    
    var boundingRegion : MKCoordinateRegion = MKCoordinateRegion()
    var localSearch : MKLocalSearch!
    var userCoordinate : CLLocationCoordinate2D!
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var places: [MKMapItem] = []
    var mapItemList: [MKMapItem] = []
    
    
    //MARK: - searching for cinema
    @IBAction func findButtonPressed(_ sender: Any) {
        print("button pressed")
        findCinema()
    }
    
    func findCinema() {
        
        //let typeOfLocation = "Restaurant"
        let typeOfLocation = "Cinema"
        
        
        if self.localSearch?.isSearching ?? false {
            self.localSearch!.cancel()
        }
        print("searching")
        SVProgressHUD.show()
        
        //finding userlocation
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = locValue.latitude
        newRegion.center.longitude = locValue.longitude
        newRegion.span.latitudeDelta = 0.112872
        newRegion.span.longitudeDelta = 0.109863
        let request = MKLocalSearch.Request()
        
        //location request by type
        request.naturalLanguageQuery = typeOfLocation
        //current location
        request.region = newRegion
        
        let completionHandler: MKLocalSearch.CompletionHandler = {response, error in
            if let actualError = error {
                
                SVProgressHUD.showError(withStatus: "Could not found place")
                print(actualError)
            }
            else {
                //all returning items
                self.places = response!.mapItems
                self.mapItemList = self.places
                let placeMarks: NSMutableArray = NSMutableArray()
                print("Search completed")
                
                //Add annotation
                for item in self.mapItemList {
                    
                   
                    let annotation = PlaceAnnotation()
                    annotation.coordinate = item.placemark.location!.coordinate
                    annotation.title = item.name
                    annotation.url = item.url
                    annotation.detailAddress = item.placemark.title
                    
                    
                    
                    //annotation.canShowCallout = true
                    //annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)
                    
                    self.mapView!.addAnnotation(annotation)
                    //zoom to pin
                    if ( item == self.mapItemList[0] ) {
                        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        self.mapView.setRegion(region, animated: true)
                    }
                    placeMarks.add(item)
                }
                
                self.boundingRegion = response!.boundingRegion
            }
            SVProgressHUD.dismiss()
        }
        
        self.localSearch = MKLocalSearch(request: request)
        
        self.localSearch!.start(completionHandler: completionHandler)
    }
    
    
    //MARK: - location button
    func addMapTrackingButton(){
        let image = UIImage(named: "find-me-icon") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height / 4), size: CGSize(width: 35, height: 35))
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.centerMapOnUserButtonClicked), for:.touchUpInside)
        mapView.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    //MARK: - location tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        print("Pin activated")
        
        if let place: PlaceAnnotation = view.annotation as? PlaceAnnotation {
         
            //place.title
            print("\(String(describing: place.title))")
            if let url = place.url {
                UIApplication.shared.open(url, options: [:])
            }
            else {
                SVProgressHUD.showError(withStatus: "No webpage found")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)
        print("pin created?")
        return annotationView
    }
}




