//
//  Rider.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/15/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import Parse

class Rider: NSObject {

    static let sharedInstance = Rider()
    
    var riderID:String?;
    var source:CLLocationCoordinate2D?;
    var destination:CLLocationCoordinate2D?;
    var startTime:NSDate?;
    var tripTime:Int?;
    
    
    func convertStringToLocation(sourceLoc:String , destLoc:String) -> Void
    {
        //geocoding string to Location
        
                let sourceURLString:String = "http://maps.googleapis.com/maps/api/geocode/json?address=\(sourceLoc)&sensor=false";
                let sourceURL:NSURL! = NSURL(string:sourceURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
                let sourceURLRequest:NSURLRequest = NSURLRequest(URL:sourceURL);
                let sourceResponse:NSURLResponse?;
        
                let sourceSession = NSURLSession.sharedSession()
                let sourceTask = sourceSession.dataTaskWithRequest(sourceURLRequest){
                    (data, response, error) -> Void in
        
                    if error != nil {
                        print("Get Error")
        
                    }else{
        
                        //var error:NSError?
                        do {
        
        
        
                            let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
        
                            print(json)
        
                            let lat:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lat") as? NSNumber)!;
        
        
                            let long:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lng") as? NSNumber)!;
        
                            self.source = CLLocationCoordinate2D(latitude:lat.doubleValue, longitude:long.doubleValue);
                            
                            let destURLString:String = "http://maps.googleapis.com/maps/api/geocode/json?address=\(destLoc)&sensor=false";
                            let destURL:NSURL! = NSURL(string:destURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
                            let destURLRequest:NSURLRequest = NSURLRequest(URL: destURL);
                            let destResponse:NSURLResponse?;
                            
                            let destSession = NSURLSession.sharedSession()
                            let destTask = destSession.dataTaskWithRequest(destURLRequest){
                                (data, response, error) -> Void in
                                if error != nil {
                                    print("Get Error")
                                    
                                }else{
                                    
                                    //var error:NSError?
                                    do {
                                        let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                                        
                                        print(json)
                                        
                                        let lat:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lat") as? NSNumber)!;
                                        
                                        
                                        let long:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lng") as? NSNumber)!;
                                        
                                        self.destination = CLLocationCoordinate2D(latitude:lat.doubleValue, longitude:long.doubleValue);
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.fetchData(self.source!, dest: self.destination!)
                                        })
                                        
                                        
                                    } catch let error as NSError {
                                        // error handling
                                        print(error.localizedDescription)
                                        
                                    }
                                    
                                }
                            }
                            
                            destTask.resume();
        
                        } catch let error as NSError {
                            // error handling
                            print(error.localizedDescription)
        
                        }
        
                    }
        
                }
                sourceTask.resume();
        
    }
    
    func fetchData(source:CLLocationCoordinate2D , dest:CLLocationCoordinate2D)->[Driver]
    {
        self.source = source;
        self.destination = dest;
        
        let sourceLoc: PFGeoPoint = PFGeoPoint();
        let destinationLoc: PFGeoPoint = PFGeoPoint();
        
        sourceLoc.latitude = ((self.source?.latitude)!);
        sourceLoc.longitude = ((self.source?.longitude)!);
        
        destinationLoc.latitude = ((self.destination?.latitude)!);
        destinationLoc.longitude = ((self.destination?.longitude)!);


        var sourceObjects:[AnyObject] = [];
        var destinationObjects:[AnyObject] = [];
        var intersectionObjects:[AnyObject] = [];
        var driverObjects:[Driver] = [];

        

        let sourceQuery = PFQuery(className: "Location");
        sourceQuery.whereKey("loc", nearGeoPoint:sourceLoc, withinMiles: 2);
        
        let innerSourceQuery = PFQuery(className: "Driver");
        innerSourceQuery.includeKey("source")
        innerSourceQuery.whereKey("source", matchesQuery: sourceQuery)
        
        do {
            
            sourceObjects = try innerSourceQuery.findObjects();
            
        } catch let error as NSError {
            // error handling
            print(error.localizedDescription)
        }
        
        let destQuery = PFQuery(className: "Location");
        destQuery.whereKey("loc", nearGeoPoint:sourceLoc, withinMiles: 2);
        
        let innerDestQuery = PFQuery(className: "Driver");
        innerDestQuery.includeKey("source")
        innerDestQuery.whereKey("source", matchesQuery: destQuery)
        
        do {
            
            destinationObjects = try innerDestQuery.findObjects();
            
        } catch let error as NSError {
            // error handling
            print(error.localizedDescription)
            
            
        }

    

        for sObject in sourceObjects
        {
            for dObject in destinationObjects
            {
                let sourcePF:PFObject = (sObject as! PFObject);
                let destPF:PFObject = (dObject as! PFObject);

                if sourcePF.objectId == destPF.objectId
                {
                    intersectionObjects.append(sObject);
                }
            }
        }
       
       for object in intersectionObjects
       {
            let parseObject:PFObject = object as! PFObject;
            let newDriverObject = Driver();
            newDriverObject.startTime = parseObject["startTime"] as! NSDate;
            newDriverObject.tripTime = parseObject["tripTime"] as! Int;
        
            let fetchedSourceObj:PFObject = parseObject["source"] as! PFObject;
            let fetchedDestObj:PFObject = parseObject["destination"] as! PFObject;

            let sourceLocationQuery = PFQuery(className: "Location");
            var sourceLocObject:[AnyObject] = [];
            sourceLocationQuery.whereKey("objectId", equalTo:fetchedSourceObj.objectId!);
            do {
                
               sourceLocObject = try sourceLocationQuery.findObjects();
                
            } catch let error as NSError {
                // error handling
                print(error.localizedDescription)
                
                
            }

        

            var destLocObject:[AnyObject] = [];
            let destLocationQuery = PFQuery(className: "Location");
            destLocationQuery.whereKey("objectId", equalTo:fetchedDestObj.objectId!);
            do {
                
                destLocObject = try destLocationQuery.findObjects();
                
            } catch let error as NSError {
                // error handling
                print(error.localizedDescription)
                
                
            }
        
            let sourcePFObject:PFObject = sourceLocObject[0] as! PFObject;
            let destPFObject:PFObject = destLocObject[0] as! PFObject;
        
        newDriverObject.source = CLLocationCoordinate2DMake(sourcePFObject["loc"].latitude as! CLLocationDegrees , sourcePFObject["loc"].longitude as! CLLocationDegrees);
        
        newDriverObject.destination = CLLocationCoordinate2DMake(destPFObject["loc"].latitude as! CLLocationDegrees , destPFObject["loc"].longitude as! CLLocationDegrees)

        

            driverObjects.append(newDriverObject);
       }

        return driverObjects;
    }
    
}
