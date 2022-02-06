//
//  LocationDetailViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 24/1/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class RoomDetailController : UIViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let database = Database.database().reference()
    
    var room:Room?
    var memberList:[String] = []
    
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var descTxt: UILabel!
    @IBOutlet weak var roomCodeTxt: UILabel!
    
    @IBOutlet weak var leaveBtn: UIButton!
    
    
    @IBAction func leaveBtn(_ sender: Any) {
        
        //alert popup
        let alert = UIAlertController(title: "Leave Room?", message: "Do you want to leave the room?", preferredStyle: .alert)

        
        let email = AppDelegate.emailRef
        let emailnew = email.replacingOccurrences(of: "@", with: "-")
        let emailnewer = emailnew.replacingOccurrences(of: ".", with: "_")
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            print("yes")
            if emailnewer == self.room?.OwnerID
            {
                //prompt message
                let errAlert = UIAlertController(title: "Cannot leave", message: "Don't leave! You squad needs a leader!", preferredStyle: .alert)
                errAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(errAlert, animated: true)
                
                
            }
            else
            {
                
                 
                //remove current room code from roomlist
                self.appDelegate.roomList.removeAll{room in
                    return room.RoomCode == self.appDelegate.room?.RoomCode
                }
                
                //remove user emailID from room memberlist
                self.appDelegate.room?.MemberList.removeAll{value in
                   return value == emailnewer}
                let newMemberList:[String] = self.appDelegate.room!.MemberList
                
                
                //removing user emailID from firebase database
                self.database.child("Rooms").child(self.appDelegate.room!.RoomCode).child("Members").setValue(newMemberList)
                
                //remove room code from user roomlist in firebase database
                self.database.child("Users").child(emailnewer).observeSingleEvent(of: .value, with: {snapshot in
                    let userData = snapshot.value as? [String:Any]
                    
                    var roomIDList:[String] = []
                    
                    
                    if userData!["RoomList"] == nil {
                        print("error")
                    }
                    else
                    {
                        let roomlist = userData!["RoomList"] as! NSArray
                        
                        
                        for roomid in roomlist
                        {
                            
                            roomIDList.append((roomid as? String)!)
                        }
                        
                    }
                    
                    roomIDList.removeAll{x in
                        return x == self.appDelegate.room?.RoomCode
                    }
                    
                    
                    self.database.child("Users").child(emailnewer).child("RoomList").setValue(roomIDList)
                
                
                
                })
                
              
                
                let successAlert = UIAlertController(title: "Success", message: "You have left the room", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                
                let storyboard = UIStoryboard(name: "Content", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Content") 
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                //redirect to content view
                
                self.present(successAlert, animated: true)
                
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Code to design UI
        leaveBtn.layer.cornerRadius = 22
        leaveBtn.layer.borderWidth = 1
        leaveBtn.layer.borderColor = .init(red: 223, green: 78, blue: 50, alpha: 1)
        
        //retrieving room value from appdelegate
        room = appDelegate.room
        memberList = room!.MemberList
        
        nameTxt.text = room!.Name
        descTxt.text = room!.Description
        roomCodeTxt.text = room!.RoomCode
        
        memberTable.delegate = self
        memberTable.dataSource = self
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
    }
    
    
}

extension RoomDetailController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return amount of records in memberlist
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTable.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        //setting cell value to emailaddress of members
        let email = memberList[indexPath.row]
        let emailnew = email.replacingOccurrences(of: "-", with: "@")
        let emailnewer = emailnew.replacingOccurrences(of: "_", with: ".")
        
        cell.textLabel!.text = emailnewer
        
        return cell
        
    }
}
