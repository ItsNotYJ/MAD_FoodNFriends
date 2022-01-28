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
    
    // Adjust the height of each cell row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Create or Join a room", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Create  ", style: .default, handler: {(action:UIAlertAction) in
            let storyboard = UIStoryboard(name: "Content", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "createRoom") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Join  ", style: .default, handler: {(action:UIAlertAction) in
            let storyboard = UIStoryboard(name: "Content", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "joinRoom") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
