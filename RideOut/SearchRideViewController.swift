//
//  SearchRideViewController.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/14/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit

class SearchRideViewController: UIViewController,updateSearchResultsDelegate,UITableViewDataSource,UITableViewDelegate {
 
    var posterDetails:PosterDetails = PosterDetails.sharedInstance;
  //  var searchController:UISearchController!;
    var searchForSource:Bool = true;
    
    @IBOutlet weak var ridesTableView: UITableView!
    @IBOutlet weak var sourceTF: UITextField!
    @IBOutlet weak var destinationTF: UITextField!

    override func viewDidLoad() {
        
   //     searchController = UISearchController();
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated);
        
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
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:RiderSearchResultTableViewCell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! RiderSearchResultTableViewCell
        
        cell.driverNameLabel!.text = "abcd";
        cell.ETALabel.text = "forever";
        cell.costLabel.text = "100$";

        return cell;
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    
    @IBAction func searchRideTapped(sender: AnyObject) {
        
        Rider.sharedInstance.convertStringToLocation(self.sourceTF.text!,destLoc: self.destinationTF.text!);
    }

    @IBAction func postRideTapped(sender: AnyObject) {
        
        // post ride to parse
        
    }
    
    @IBAction func sourceTFTapped(sender: AnyObject) {
        
        searchForSource = true;
        self.performSegueWithIdentifier("showSearchFromSearchRide", sender: self);
        
    }
    
    @IBAction func destinationTFTapped(sender: AnyObject) {
        
        searchForSource = false;
        self.performSegueWithIdentifier("showSearchFromSearchRide", sender: self);
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "showSearchFromSearchRide") {
            // pass data to next view
            
            let vc:SearchResultsViewController = segue.destinationViewController as! SearchResultsViewController;
            vc.delegate = self;
            
        }
        
    }

}
