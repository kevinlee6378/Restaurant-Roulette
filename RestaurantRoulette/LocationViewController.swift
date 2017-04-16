//
//  ViewController.swift
//  location
//
//  Created by Labuser on 4/2/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class LocationViewController : UIViewController {
    
    
    var mapView: MKMapView!
    var locationSearchTable: LocationSearchTable!
    
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMapView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //let locationSearchTable = locationSearchTable()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Choose a location"
        
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    
    func setupMapView() {
        self.mapView = MKMapView()
        self.mapView.frame = self.view.frame
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.view.addSubview(self.mapView)
        //mapView.showsUserLocation = true
    }
    
    func setupTableView() {
        self.locationSearchTable = LocationSearchTable()
        self.locationSearchTable.view.frame = self.view.frame
        self.view.addSubview(self.locationSearchTable.view)
    }
    
    
}



extension LocationViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension LocationViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        let count = self.navigationController?.viewControllers.count;
        print(count!)
        let menuVC = self.navigationController?.viewControllers[count!-2] as! MenuViewController
        menuVC.latitude = String(describing: selectedPin?.coordinate.latitude)
        menuVC.longitude = String(describing: selectedPin?.coordinate.longitude)
    }
    
}


