//
//  Driver.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/15/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import Parse

class Driver: NSObject {
    
    var driverID:String?;
    var source:CLLocationCoordinate2D?;
    var destination:CLLocationCoordinate2D?;
    var startTime:NSDate?;
    var tripTime:Int?;
    var wayPoints:[AnyObject] = []
    
    func PostData()->Void
    {
        let sourceLocation = PFObject(className:"Location")
        let destLocation = PFObject(className:"Location")

        var sourceLoc: PFGeoPoint = PFGeoPoint();
        var destinationLoc: PFGeoPoint = PFGeoPoint();
        
        sourceLoc.latitude = ((self.source?.latitude)!);
        sourceLoc.longitude = ((self.source?.longitude)!);
        
        destinationLoc.latitude = ((self.destination?.latitude)!);
        destinationLoc.longitude = ((self.destination?.longitude)!);


        sourceLocation["loc"] = sourceLoc;
        destLocation["loc"] = destinationLoc;

        let gameScore = PFObject(className:"Driver")
        gameScore["startTime"] = startTime
        gameScore["tripTime"] = tripTime;
        gameScore["source"] = sourceLocation;
        gameScore["destination"] = destLocation;
        gameScore["wayPoints"] = wayPoints;
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }

    }

}
