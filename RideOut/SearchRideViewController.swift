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
    var results:[AnyObject] = [];
    
    @IBOutlet weak var ridesTableView: UITableView!
    @IBOutlet weak var sourceTF: UITextField!
    @IBOutlet weak var destinationTF: UITextField!

    @IBOutlet weak var resultsTableView: UITableView!
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
        return self.results.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:RiderSearchResultTableViewCell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! RiderSearchResultTableViewCell
        
        var drv:Driver = self.results[indexPath.row] as! Driver;
        
        cell.driverNameLabel!.text = "abcd";
        cell.costLabel.text = String(drv.cost);
        cell.costLabel.text = "100$";

        return cell;
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    
    @IBAction func searchRideTapped(sender: AnyObject) {
        
        Rider.sharedInstance.convertStringToLocation(self.sourceTF.text!, destLoc: self.destinationTF.text!) { (result) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.results = result;
                self.resultsTableView.reloadData();
                
            })

            
        }
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
