//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Yuichi Kuroda on 9/23/15.
//  Copyright (c) 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate,
                                UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var businesses: [Business]!
  var filteredBusinesses: [Business]?
  var currentSearchTerm = "Restaurants"
  var currentFilters = [String:AnyObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    
    let searchBar = UISearchBar()
    searchBar.delegate = self
    searchBar.sizeToFit()
    searchBar.placeholder = "Search Yelp"
    
    navigationItem.titleView = searchBar
    
    KVNProgress.showWithStatus("Searching...")
    
    Business.searchWithTerm(currentSearchTerm, completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.doSearch(self.currentSearchTerm)
      
      for business in businesses {
        print(business.name!)
        print(business.address!)
      }
    })

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if filteredBusinesses != nil {
      return filteredBusinesses!.count
    } else if businesses != nil {
      return businesses!.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
    
    if filteredBusinesses?.count > 0 {
      cell.business = filteredBusinesses![indexPath.row]
    } else {
      cell.business = businesses[indexPath.row]
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      doSearch(nil)
    } else {
      currentSearchTerm = searchText
      doSearch(searchText)
    }
  }
  
  func doSearch(searchTerm: String?) {
    doSearch(searchTerm, sort: currentFilters["sort"] as? Int, categories: currentFilters["categories"] as? [String], deals: currentFilters["deals"] as? Bool, radius: currentFilters["radius"] as? Double)
  }
  
  func doSearch(searchTerm: String?, sort: Int?, categories: [String]?, deals: Bool?, radius: Double?) {
    let term = searchTerm ?? "Restaurants"
    var sortMode: YelpSortMode?
    
    if sort != nil {
      sortMode = YelpSortMode(rawValue: sort!)
    }
    
    KVNProgress.showWithStatus("Searching...")
    
    Business.searchWithTerm(term, sort: sortMode, categories: categories, deals: deals, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
      if error == nil {
        self.businesses = businesses
        self.tableView.reloadData()
        KVNProgress.dismiss()
      } else {
        // TODO: Show error
      }
    }
  }
  
  /*
  // MARK: - Navigation
  */
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    let navigationController = segue.destinationViewController as! UINavigationController
    let filtersViewController = navigationController.topViewController as! FiltersViewController
    
    filtersViewController.delegate = self
  }
  
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
    currentFilters = filters
    
    doSearch(currentSearchTerm)
  }
}
