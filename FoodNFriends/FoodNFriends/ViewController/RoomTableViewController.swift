//
//  RoomTableViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation

import Foundation
import UIKit

class RoomTableViewController : UITableViewController {
    
    var roomList:[Room] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomList = appDelegate.roomList
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roomList = appDelegate.roomList
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let room = roomList[indexPath.row]
        cell.textLabel!.text = "\(room.Name)"
        cell.detailTextLabel!.text = "\(room.Description)"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let room = roomList[indexPath.row]
        appDelegate.room = room
        
       

            
            
            
            
     
        }
    
    
}
