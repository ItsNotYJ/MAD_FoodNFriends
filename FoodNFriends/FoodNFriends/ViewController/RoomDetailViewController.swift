//
//  LocationDetailViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 24/1/22.
//

import Foundation
import UIKit

class RoomDetailController : UIViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var room:Room?
    var memberList:[String] = []
    
    
    
    @IBOutlet weak var memberTable: UITableView!
    
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var descTxt: UILabel!

    @IBAction func leaveBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Leave Room?", message: "Do you want to leave the room?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            print("yes")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        room = appDelegate.room
        memberList = room!.MemberList
        
        nameTxt.text = room!.Name
        descTxt.text = room!.Description
        
        memberTable.delegate = self
        memberTable.dataSource = self
        
    }
    
    
}

extension RoomDetailController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTable.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        
        cell.textLabel!.text = "\(memberList[indexPath.row])"
        
        return cell
        
    }
}



