 //
//  SearchResultsViewController.swift
//  RideOut
//
//  Created by Gaurav Nijhara on 11/14/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit

protocol updateSearchResultsDelegate
{
    func updateSearchField(searchedTerm:String)->Void;
    func updateWayPoint(wayPoints:[AnyObject])->Void;

}

class SearchResultsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,UISearchBarDelegate {

    var isDestinationAdded:Bool!;
    var areWayPointsNeeded:Bool = false;
    var posterDetails:PosterDetails = PosterDetails.sharedInstance;
    var delegate:updateSearchResultsDelegate?;
    
    let googlePlaceClient:GMSPlacesClient? = GMSPlacesClient.sharedClient();
    var autoCompleteFilter:GMSAutocompleteFilter?

    var resultsArr:[AnyObject] = [];
    var wayPointsArr:[AnyObject] = [];
    var shouldShowSearchResults = false
    var searchController:UISearchController!;
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // init autocomplete filter
        autoCompleteFilter = GMSAutocompleteFilter.init();
        autoCompleteFilter?.type = GMSPlacesAutocompleteTypeFilter.City;

        //configure search display controller
        searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self;
        //searchController.dimsBackgroundDuringPresentation = true;
        searchController.searchBar.placeholder = "Type in a City/Area/Locality"
        searchController.searchBar.delegate = self;
        searchController.searchBar.sizeToFit()
        
        resultsTableView.tableHeaderView = searchController.searchBar;
        
        resultsTableView.allowsMultipleSelectionDuringEditing = false;
        
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(self.wayPointsArr.count > 0 && indexPath.row < self.wayPointsArr.count)
        {
            return 50.0
        }else
        {
            return 44.0
        }
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var autoCompleteResults:Int  = self.resultsArr.count;
        if autoCompleteResults > 10
        {
            autoCompleteResults = 10;
        }
        
        return autoCompleteResults + self.wayPointsArr.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cellIndentifier = "systemSubtitle";
        var cell:UITableViewCell? = nil;
        
        if(self.wayPointsArr.count > 0 && indexPath.row < self.wayPointsArr.count)
        {
            let cell:SearchResultsTableViewCell = tableView.dequeueReusableCellWithIdentifier("waypointIdentifier") as! SearchResultsTableViewCell;
            
            cell.wayPointName.text = self.wayPointsArr[indexPath.row].attributedFullText!.string
            
            if indexPath.row == 0 {
                
                cell.indicatorLabel.text = "D";
                cell.indicatorLabel.backgroundColor = UIColor.greenColor()

                
            }else {
                
                cell.indicatorLabel.text = "W";
                cell.indicatorLabel.backgroundColor = UIColor.blueColor()


            }
            
            return cell;
        } else {
        
            if cell == nil
            {
                cell = UITableViewCell.init(style:UITableViewCellStyle.Default, reuseIdentifier: cellIndentifier)
            }
            
            cell!.backgroundColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.init(descriptor: UIFontDescriptor.init(name: "Helvetica-Light", size: 12), size: 12)
            let text:NSString = self.resultsArr[indexPath.row-self.wayPointsArr.count].attributedFullText!.string
            cell?.textLabel?.text = text as String
            
            return cell!;
        }
    }


    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.row < self.wayPointsArr.count{
            return true;
        }
        return false;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            self.wayPointsArr.removeAtIndex(indexPath.row);
            self.resultsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        resultsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        resultsTableView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        self.queryForNewString(searchString);
        
        // Reload the tableview.
        resultsTableView.reloadData()
    }
    
    func queryForNewString(query:String?) -> Void
    {
        googlePlaceClient?.autocompleteQuery(query!, bounds: nil, filter: autoCompleteFilter, callback: { (results, error:NSError?) -> Void in
            
            if results != nil
            {
                self.resultsArr = []
                for result in results!
                {
                    if let result = result as? GMSAutocompletePrediction {
                        self.resultsArr.append(result)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.resultsTableView.reloadData();
                })
                
            }
        })
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // add delegate methods.
        if indexPath.row < self.wayPointsArr.count
        {
            return;
        }
        
        let place:GMSAutocompletePrediction = self.resultsArr[indexPath.row-self.wayPointsArr.count] as! GMSAutocompletePrediction

        if (self.areWayPointsNeeded == true ) {
            self.wayPointsArr.append(self.resultsArr[indexPath.row-self.wayPointsArr.count]);
            
            var indices:[NSIndexPath] = [NSIndexPath(forItem:self.wayPointsArr.count-1, inSection: 0)];

            self.resultsArr.removeAtIndex(indexPath.row-self.wayPointsArr.count+1);
            
            self.resultsTableView .beginUpdates();
            
            self.resultsTableView.reloadRowsAtIndexPaths(indices, withRowAnimation: UITableViewRowAnimation.Right);
            self.resultsTableView.endUpdates();
            
            
        } else {
            if let delegate = self.delegate {
                delegate.updateSearchField(place.attributedFullText.string);
            }
        }
    
    }

    @IBAction func doneBtnPressed(sender: AnyObject) {
        if self.delegate != nil && self.wayPointsArr.count > 0{
            
            let place:GMSAutocompletePrediction = self.wayPointsArr[0] as! GMSAutocompletePrediction
            self.wayPointsArr.removeAtIndex(0);
            
            self.delegate!.updateSearchField(place.attributedFullText.string)
            self.delegate!.updateWayPoint(self.wayPointsArr);
        }
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
