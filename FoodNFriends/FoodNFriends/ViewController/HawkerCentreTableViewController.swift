//
//  HawkerCentreViewController.swift
//  FoodNFriends
//
//  Created by Jae on 19/1/22.
//

import Foundation
import UIKit

class HawkerCentreTableViewController: UITableViewController {
    // Only require the app delegate to store the Hawker Centre API data once
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // TODO: Might shift this API call somewhere else to save the hawker centre list as to be more efficient coding wise
        // Only run the API code once and only when the hawker centre list is empty during the user's session
        if appDelegate.hawkerCentreList.count == 0 {
            HawkerApi().GetHawkerCentres { (hc) in
                self.appDelegate.hawkerCentreList = hc
                self.tableView.reloadData() // Reload data once it loads
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData() // Reload data
    }
    
    // Determine number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Determine number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.hawkerCentreList.count
    }
    
    // Display data into cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HawkerCell", for: indexPath)
        
        // Store current hawkerCentre as variable based on indexPath.row
        let hawkerCentre: HawkerCentre = appDelegate.hawkerCentreList[indexPath.row]
        
        // Hawker Centre Name
        cell.textLabel?.text = hawkerCentre.name
        
        // Hawker Centre Type
        if hawkerCentre.type == "HC" {
            cell.detailTextLabel?.text = "Hawker Centre"
        }
        else {
            cell.detailTextLabel?.text = "Market and Hawker Centre"
        }
        
        return cell
    }
    
    // User selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the selected hawker centre indexPath.row
        appDelegate.hawkerCentreIndex = indexPath.row
    }
    
    // Adjust the height of each cell row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
