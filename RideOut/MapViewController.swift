//
//  MapViewController.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/14/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let poster:PosterDetails = PosterDetails.sharedInstance;
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
    }
    
}
