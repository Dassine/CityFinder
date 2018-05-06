//
//  MapViewController.swift
//  CityFinder
//
//  Created by D. on 2018-05-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var city: City?
    
    override func viewDidAppear(_ animated: Bool) {
        if let city = city {
            // Set City location on the displayed map
            if let lat = city.coord.lat, let long = city.coord.lon {
                let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                
                mapView.setRegion(region, animated: true)
            }
            
            // Set Navigation Bar title
            navigationItem.title = city.name + " - " + city.country
        }
    }
}
