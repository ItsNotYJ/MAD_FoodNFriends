//
//  CreateRoomViewController.swift
//  FoodNFriends
//
//  Created by elgin on 27/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateRoomViewController: UIViewController {
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private let database = Database.database().reference()
    var roomList:[String] = []
    var existingroomData:[String] = []
    var emailnewer = ""
    @IBOutlet weak var rCodeTxt: UITextField!
    @IBOutlet weak var rNametxt: UITextField!
    @IBOutlet weak var desctxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let email = AppDelegate.emailRef
        let emailnew = email.replacingOccurrences(of: "@", with: "-")
        emailnewer = emailnew.replacingOccurrences(of: ".", with: "_")
        self.database.child("Users").child(emailnewer).observeSingleEvent(of: .value, with: {snapshot in
                            let userData = snapshot.value as? [String:Any]

                            if userData!["RoomList"] == nil {
                                print("error")
                            }
                            else
                            {

                                self.roomList = (userData!["RoomList"] as! NSArray) as! [String]
        
                            }
        })
        
        self.database.child("ExistingRooms").observeSingleEvent(of: .value, with: {snapshot in
                            let existRoom = snapshot.value as? [String:Any]

                            if existRoom!["Code"] == nil {
                                print("error")
                            }
                            else
                            {

                                self.existingroomData = (existRoom!["Code"] as! NSArray) as! [String]
        
                            }
        })
    }
    
    @IBAction func createBtn(_ sender: Any) {
        let roomcode = rCodeTxt.text!, roomname = rNametxt.text!, desc = desctxt.text!
        var roomcodetaken = false
        
        if (roomcode == "" || roomname == "" || desc == "")
        {
            let alert = UIAlertController(title: "Error", message: "Inputs cannot be empty", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            for x in existingroomData
            {
                if x == roomcode
                {
                    roomcodetaken = true
                }
            }
            
            if roomcodetaken == false
            {
                
                roomList.append(roomcode)
                existingroomData.append(roomcode)
                let roomInfo:[String:String] = ["Description" : desc, "Name" : roomname, "RoomCode" : roomcode, "OwnerID" : emailnewer]
                let databaseRef = Database.database().reference()
                //setting roominfo
                databaseRef.child("Rooms").child(roomcode).setValue(roomInfo)
                
                //add member into room
                databaseRef.child("Rooms").child(roomcode).child("Members").setValue([emailnewer])
                
                //add roomcode to user
                databaseRef.child("Users").child(emailnewer).child("RoomList").setValue(roomList)
                
                //add roomcode to existingrooms
                databaseRef.child("ExistingRooms").child("Code").setValue(existingroomData)
                
                let testuser = Room(name: roomname, description: desc, ownerID: emailnewer, roomCode: roomcode,locationList: [], memberList: [emailnewer])
                self.appDelegate.roomList.append(testuser)
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Room code is taken", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
}
