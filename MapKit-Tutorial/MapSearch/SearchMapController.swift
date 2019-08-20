//
//  ViewController.swift
//  MapKit-Tutorial
//
//  Created by Avisa on 20/8/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class SearchMapController: UIViewController {
    
    var selectedPin: MKPlacemark? = nil
    
    var resultSearchController: UISearchController? = nil
    
    // The CLLocationManager variable gives you access to the location manager throughout the  scope of the controller.
    let locationManager = CLLocationManager()
    
    lazy var myMap: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLocationManager()
        setupViews()
        setupSearchResultList()
    }
    
    fileprivate func setupSearchResultList() {
        
        let locationListController = LocationSearchList(collectionViewLayout: UICollectionViewFlowLayout())
        
        locationListController.myMap = myMap
        
        locationListController.handleMapSearchDelegate = self
   
        resultSearchController = UISearchController(searchResultsController: locationListController)
        
//        present(locationListController, animated: true, completion: nil)
        
        resultSearchController?.searchResultsUpdater = locationListController
        
        // This configures the search bar, and embeds it within the navigation bar.
        
        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        
        
    }
    
    fileprivate func setupViews() {
        
        view.addSubview(myMap)
        myMap.anchor(top: view.topAnchor, paddingTop: 0, left: view.leftAnchor, paddingLeft: 0, bottom: view.bottomAnchor, paddingBottom: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        
    }
    
    fileprivate func setupLocationManager() {
        
       locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // help to create Vc embeded in navigationController
    func templateNavController( rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        
        let navController = UINavigationController(rootViewController: viewController)
      
        return navController
    }
}

extension SearchMapController: CLLocationManagerDelegate {
    // This method gets called when the user responds to the permission dialog. If the user chose Allow, the status becomes CLAuthorizationStatus.AuthorizedWhenInUse.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // This gets called when location information comes back. You get an array of locations, but you’re only interested in the first item. You don’t do anything with it yet, but eventually you will zoom to this location.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // In order to zoom to this location, you need to perform a few intermediate steps. You define a map region, which is a combination of the map center (coordinate) and zoom level (span). The coordinate is property from the first location object. And the span is an arbitrary area of 0.05 degrees longitude and latitude.
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            myMap.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to search for location:", error)
    }
    
}

extension SearchMapController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        let allAnnotations = self.myMap.annotations
        self.myMap.removeAnnotations(allAnnotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        myMap.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        
        myMap.setRegion(region, animated: true)
    }
    
    
}

// The last step is to customize the map pin callout with a button that takes you to Apple Maps for driving directions.

extension SearchMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            // return nil so map view result "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = myMap.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        
        button.setBackgroundImage(UIImage(named: "icons8-worldwide_location")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelGetDirection), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    @objc private func handelGetDirection() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
