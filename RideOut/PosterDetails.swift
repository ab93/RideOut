//
//  PosterDetails.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/14/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit

class PosterDetails: NSObject {

    static let sharedInstance = PosterDetails()

    var sourceLoc:CLLocationCoordinate2D?;
    var destinationLoc:CLLocationCoordinate2D?;
    var wayPoints:[AnyObject] = [];
    
    
}
