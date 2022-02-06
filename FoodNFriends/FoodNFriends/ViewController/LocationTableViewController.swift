//
//  LocationTableViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation
import UIKit

class LocationTableViewController : UITableViewController {
    
    
    //initializing locationList
    var locationList:[Location] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieving locationList from appDelegate
        locationList = appDelegate.room!.LocationList
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        // Reload Data
        self.tableView.reloadData()
    }
    
    // Determine number of sections
    override func viewDidAppear(_ animated: Bool) {
        
        //refreshing locationList
        locationList = appDelegate.room!.LocationList
        self.tableView.reloadData()
    }
    
    // Determine number of rows
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Display data into cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returing amount of records in locationList
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        // Retrieve location object from locationList
        let location = locationList[indexPath.row]
        
        // Set labels with location data
        cell.textLabel!.text = "\(location.Description)"
        cell.detailTextLabel!.text = "\(location.Name)"
        
        return cell
    }
    
    // User selects location and enters the detailed view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.location = locationList[indexPath.row]
    }
    
    // Adjust the height of each cell row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
