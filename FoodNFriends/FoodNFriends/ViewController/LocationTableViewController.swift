//
//  LocationTableViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation
import UIKit

class LocationTableViewController : UITableViewController {
    
    var locationList:[Location] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationList = appDelegate.room!.LocationList
        
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationList = appDelegate.room!.LocationList
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = locationList[indexPath.row]
        
        cell.textLabel!.text = "\(location.Name)"
        cell.detailTextLabel!.text = "\(location.Description)"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.location = locationList[indexPath.row]
        
    }
    
}
