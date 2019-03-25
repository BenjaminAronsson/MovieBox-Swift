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
    
   //  var url = https://maps.googleapis.com/maps/api/place/search/json?location=41.104805,29.024291
    
 //   &radius=50000&sensor=true&key=AIzaSyAVH0qHD6BPxRlnck3rIqcxC5TTwOTyfds&types=gas_station||shopping_mall
    
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
    
    // MARK - CLLocationManagerDelegate
    
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
                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = locValue
//                annotation.title = "Movie lover"
//                annotation.subtitle = "current location"
//                mapView.addAnnotation(annotation)
                
                userCoordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
            }
        }
    }
    
    //var delegate : NearByDelegate?
    var boundingRegion : MKCoordinateRegion = MKCoordinateRegion()
    var localSearch : MKLocalSearch!
    //var locationManager : CLLocationManager!
    var userCoordinate : CLLocationCoordinate2D!
    //var locValue:CLLocationCoordinate2D!
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var places: [MKMapItem] = []
    //var strCategory : String!
    //var viewDetail : UIView!
    
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
//                let alert = UIAlertController(title: "Could not find places",
//                                              message: actualError.localizedDescription,
//                                              preferredStyle: .alert)
//
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(defaultAction)
//                self.present(alert, animated: true, completion: nil)
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
                    self.mapView!.addAnnotation(annotation)
                    placeMarks.add(item)
                    
                }
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationMapData"), object: placeMarks)
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryName"), object: self.strCategory)
                
                self.boundingRegion = response!.boundingRegion
            }
            //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
        }
        
        self.localSearch = MKLocalSearch(request: request)
        
        self.localSearch!.start(completionHandler: completionHandler)
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    //MARK - location button
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

    
}
