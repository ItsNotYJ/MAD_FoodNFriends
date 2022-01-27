//
//  JoinRoomController.swift
//  FoodNFriends
//
//  Created by elgin on 27/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class JoinRoomViewController: UIViewController {
    let fireBase:FirebaseDAL = FirebaseDAL()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private let database = Database.database().reference()
    var existingroomData:[String] = []
    var roomList:[String] = []
    var emailnewer = ""
    @IBOutlet weak var rCodeTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let email = AppDelegate.emailRef
        let emailnew = email.replacingOccurrences(of: "@", with: "-")
        emailnewer = emailnew.replacingOccurrences(of: ".", with: "_")
        
        self.database.child("ExistingRooms").observeSingleEvent(of: .value, with: {snapshot in
            let existRoom = snapshot.value as? [String:Any]
            
            if existRoom!["Code"] == nil {
                print("error 2")
            }
            else
            {
                
                self.existingroomData = (existRoom!["Code"] as! NSArray) as! [String]
                
            }
        })
        
        self.database.child("Users").child(emailnewer).observeSingleEvent(of: .value, with: {snapshot in
            let userData = snapshot.value as? [String:Any]
            
            if userData!["RoomList"] == nil {
                print("error 3")
            }
            else
            {
                
                self.roomList = (userData!["RoomList"] as! NSArray) as! [String]
                
            }
        })
    }
    
    @IBAction func joinBtn(_ sender: Any) {
        let roomcode = rCodeTxt.text!
        var roomexist = false
        var inroom = false
        var testList:[String] = []
        if rCodeTxt.text! == ""
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a room code", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            for x in existingroomData
            {
                if x == roomcode
                {
                    roomexist = true
                    for c in self.roomList
                    {
                        if c == roomcode
                        {
                            inroom = true
                            break
                        }
                    }
                    
                    if inroom == false
                    {
                        self.fireBase.loadFromFireBase(roomID: roomcode,completionHandler: { [self] (success) -> Void in
                            if success {
                                print(self.appDelegate.roomList.count)
                                for y in appDelegate.roomList
                                {
                                    if y.RoomCode == roomcode
                                    {
                                        print(y.MemberList)
                                        testList = y.MemberList
                                        break
                                    }
                                    else
                                    {
                                        print(y.RoomCode)
                                    }
                                }
                                self.roomList.append(roomcode)
                                testList.append(self.emailnewer)
                                let databaseRef = Database.database().reference()
                                //add member into room
                                databaseRef.child("Rooms").child(roomcode).child("Members").setValue(testList)
                                
                                //add roomcode to user
                                databaseRef.child("Users").child(self.emailnewer).child("RoomList").setValue(self.roomList)
                                
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                            else
                            {
                                print("lmao")
                            }
                        })
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Error", message: "You have already joined the room", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    break
                }
            }
            if roomexist == false
            {
                let alert = UIAlertController(title: "Error", message: "Room does not exist", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        
    }
    
}
