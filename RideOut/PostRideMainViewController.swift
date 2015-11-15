//
//  PostRideMainViewController.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/14/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import TagListView

class PostRideMainViewController: UIViewController,updateSearchResultsDelegate {

    var posterDetails:PosterDetails = PosterDetails.sharedInstance;
    var searchController:UISearchController!;
    var searchForSource:Bool = true;
    
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var tagViewHeight: NSLayoutConstraint!
    @IBOutlet weak var googleMapView: UIView!
    @IBOutlet weak var sourceTF: UITextField!
    @IBOutlet weak var destinationTF: UITextField!

    override func viewDidLoad() {
        
        searchController = UISearchController();
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated);
        
        self.setupTags();
    }
    
    func setupTags() -> Void
    {        
        for tag in posterDetails.wayPoints
        {
            let tagText:String = (tag as! GMSAutocompletePrediction).attributedFullText.string;
            self.tagView.addTag(tagText);
        }
    }
    
    func updateSearchField(searchedTerm:String)->Void
    {
        if searchForSource == true{
            self.sourceTF!.text = searchedTerm;
        }else {
            self.destinationTF!.text = searchedTerm;
        }
    }

    func updateWayPoint(wayPoints:[AnyObject])->Void
    {
        posterDetails.wayPoints.appendContentsOf(wayPoints) ;
    }

    @IBAction func postRideTapped(sender: AnyObject) {
        
        // post ride to parse
        
    }
    
    @IBAction func sourceTFTapped(sender: AnyObject) {
        
        searchForSource = true;
        self.performSegueWithIdentifier("showSearch", sender: self);
        
    }
    
    @IBAction func destinationTFTapped(sender: AnyObject) {
        
        searchForSource = false;
        self.performSegueWithIdentifier("showSearch", sender: self);

    }
    
    
    @IBAction func addMoreWayPoint(sender: AnyObject) {
        
        searchForSource = true;
        self.performSegueWithIdentifier("showSearch", sender: self);

    }
    @IBAction func addRoute(sender: AnyObject) {
        
        var mapFrame = CGRectMake(0, 0,googleMapView.frame.size.width, googleMapView.frame.size.height);
        var mapView:GMSMapView! = GMSMapView(frame: mapFrame);
        mapView.mapType = kGMSTypeNormal;
        
        

        self.googleMapView.addSubview(mapView);
        
        //        let destURLString:Sltring = "http://maps.googleapis.com/maps/api/geocode/json?address=\(self.destinationTF.text!) &sensor=false";

        let urlString:String = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.sourceTF.text!)&destination=\(self.destinationTF.text!)&key=AIzaSyBF6SPXnRzKjp_-km8JtaLNBCDFEikL1Io"

        let sourceURL:NSURL! = NSURL(string:urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
        let sourceURLRequest:NSURLRequest = NSURLRequest(URL:sourceURL);

        
        let sourceSession = NSURLSession.sharedSession()
        let sourceTask = sourceSession.dataTaskWithRequest(sourceURLRequest) { (data, response, error) -> Void in
            if error != nil {
                print("Get Error")
                
            }else{
                
                //var error:NSError?
                do {
                    
                    
                    
                    let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    
                    print(json)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let sourceCoordinate:NSDictionary = ((json["routes"]!![0]["legs"]!![0]["start_location"] as? NSDictionary)!);
                        
                        let destCoordinate:NSDictionary = ((json["routes"]!![0]["legs"]!![0]["end_location"] as? NSDictionary)!);


                        let sourceCLCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:(sourceCoordinate.objectForKey("lat") as? Double)!, longitude:(sourceCoordinate.objectForKey("lng") as? Double)!);
                        let destCLCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:destCoordinate.objectForKey("lat") as! Double!, longitude:destCoordinate.objectForKey("lng") as! Double!);

                        let cameraBounds:GMSCoordinateBounds = GMSCoordinateBounds(coordinate: sourceCLCoordinate, coordinate: destCLCoordinate);
                        let camera:GMSCameraPosition = mapView.cameraForBounds(cameraBounds, insets: UIEdgeInsetsMake(20,30,20,30));
                        camera
                        mapView.camera = camera;
                        
                        var sourceMarker:GMSMarker = GMSMarker(position:sourceCLCoordinate);
                        sourceMarker.map = mapView

                        var destMarker:GMSMarker = GMSMarker(position:destCLCoordinate);
                        destMarker.map = mapView

                        let navPath:GMSPath = GMSPath(fromEncodedPath:((json["routes"]!![0]["overview_polyline"]!!["points"] as? String)!))
                        let line:GMSPolyline = GMSPolyline(path: navPath);
                        line.strokeWidth = 4.0;
                        line.strokeColor = UIColor.greenColor();
                        line.map = mapView;
                    });
                    
                } catch let error as NSError {
                    // error handling
                    print(error.localizedDescription)
                    
                    
                }
                
            }
        }

        sourceTask.resume();
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "showSearch") {
            // pass data to next view
            
            let vc:SearchResultsViewController = segue.destinationViewController as! SearchResultsViewController;
            vc.delegate = self;
            vc.areWayPointsNeeded = self.searchForSource;
            
        }

    }
}



//        let sourceURLString:String = "http://maps.googleapis.com/maps/api/geocode/json?address=\(self.sourceTF.text!)&sensor=false";
//        let sourceURL:NSURL! = NSURL(string:sourceURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
//        let sourceURLRequest:NSURLRequest = NSURLRequest(URL:sourceURL);
//        let sourceResponse:NSURLResponse?;
//
//        let sourceSession = NSURLSession.sharedSession()
//        let sourceTask = sourceSession.dataTaskWithRequest(sourceURLRequest){
//            (data, response, error) -> Void in
//
//            if error != nil {
//                print("Get Error")
//
//            }else{
//
//                //var error:NSError?
//                do {
//
//
//
//                    let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
//
//                    print(json)
//
//                    let lat:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lat") as? NSNumber)!;
//
//
//                    let long:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lng") as? NSNumber)!;
//
//                    self.posterDetails.sourceLoc = CLLocationCoordinate2D(latitude:lat.doubleValue, longitude:long.doubleValue);
//
//                } catch let error as NSError {
//                    // error handling
//                    print(error.localizedDescription)
//
//
//                }
//
//            }
//
//
////            NSString *urlString = [NSString stringWithFormat:
////            @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
////            @"https://maps.googleapis.com/maps/api/directions/json",
////            mapView.myLocation.coordinate.latitude,
////            mapView.myLocation.coordinate.longitude,
////            destLatitude,
////            destLongitude,
////            @"Your Google Api Key String"];
////            NSURL *directionsURL = [NSURL URLWithString:urlString];
////
////
////            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
////            [request startSynchronous];
////            NSError *error = [request error];
////            if (!error) {
////                NSString *response = [request responseString];
////                NSLog(@"facebook.com/truqchal %@",response);
////                NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
////                GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
////                GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
////                singleLine.strokeWidth = 7;
////                singleLine.strokeColor = [UIColor greenColor];
////                singleLine.map = self.mapView;
////            }
////            else NSLog(@"facebook.com/truqchal%@",[request error]);
//
//
//
//        }
//        sourceTask.resume();
//
//        let destURLString:String = "http://maps.googleapis.com/maps/api/geocode/json?address=\(self.destinationTF.text!) &sensor=false";
//        let destURL:NSURL! = NSURL(string:destURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
//        let destURLRequest:NSURLRequest = NSURLRequest(URL: destURL);
//        let destResponse:NSURLResponse?;
//
//        let destSession = NSURLSession.sharedSession()
//        let destTask = destSession.dataTaskWithRequest(destURLRequest){
//            (data, response, error) -> Void in
//            if error != nil {
//                print("Get Error")
//
//            }else{
//
//                //var error:NSError?
//                do {
//                    let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
//
//                    print(json)
//
//                    let lat:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lat") as? NSNumber)!;
//
//
//                    let long:NSNumber = (((((json.objectForKey("results") as? NSArray)!.objectAtIndex(0) as? NSDictionary)!.objectForKey("geometry") as? NSDictionary)!.objectForKey("location") as? NSDictionary)!.objectForKey("lng") as? NSNumber)!;
//
//                    self.posterDetails.destinationLoc = CLLocationCoordinate2D(latitude:lat.doubleValue, longitude:long.doubleValue);
//
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.performSegueWithIdentifier("mapVCSegue", sender: self);
//                    })
//
//
//                } catch let error as NSError {
//                    // error handling
//                    print(error.localizedDescription)
//
//
//                }
//
//            }
//        }
//
//        destTask.resume();


////            NSString *urlString = [NSString stringWithFormat:
////            @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
////            @"https://maps.googleapis.com/maps/api/directions/json",
////            mapView.myLocation.coordinate.latitude,
////            mapView.myLocation.coordinate.longitude,
////            destLatitude,
////            destLongitude,
////            @"Your Google Api Key String"];
////            NSURL *directionsURL = [NSURL URLWithString:urlString];
////
////
////            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
////            [request startSynchronous];
////            NSError *error = [request error];
////            if (!error) {
////                NSString *response = [request responseString];
////                NSLog(@"facebook.com/truqchal %@",response);
////                NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
////                GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
////                GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
////                singleLine.strokeWidth = 7;
////                singleLine.strokeColor = [UIColor greenColor];
////                singleLine.map = self.mapView;
////            }
////            else NSLog(@"facebook.com/truqchal%@",[request error]);
