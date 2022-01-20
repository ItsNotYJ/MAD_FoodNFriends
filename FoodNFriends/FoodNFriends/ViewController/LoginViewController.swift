//
//  LoginViewController.swift
//  FoodNFriends
//
//  Created by elgin on 13/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var userRoomList:[Room] = []
    private let database = Database.database().reference()
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    var dummyuser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTxt.isSecureTextEntry = true
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        if emailTxt.text == "" || passwordTxt.text == ""
        {
            let alert = UIAlertController(title: "Empty input", message: "Please enter all input", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { result, error in
                
                guard error == nil else {
                    //fail to sign in
                    let alert = UIAlertController(title: "Incorrect Username/Password", message: "Please try again", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                AppDelegate.emailRef = self.emailTxt.text!
                
                
                
                var tempList:[String] = []
                
                
                
                self.database.child("Users").child("user1").observeSingleEvent(of: .value, with: {snapshot in
                    let userData = snapshot.value as? [String:Any]
                    
                    
                    
                    
                    if userData!["RoomList"] == nil {
                        print("error")
                    }
                    else
                    {
                        let roomlist = userData!["RoomList"] as! NSArray
                        
                        
                        for roomid in roomlist
                        {
                            
                            tempList.append((roomid as? String)!)
                        }
                        
                    }
                    
                    for roomid in tempList
                    {
                        
                        self.loadFromFireBase(roomID: roomid)
                        
                        
                    }
                })
                
                let storyboard = UIStoryboard(name: "Content", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            })
        }
    }
    
    func loadFromFireBase(roomID : String)-> () {
        database.child("Rooms").child(roomID).observeSingleEvent(of: .value, with: {snapshot in
            let roomData = snapshot.value as? [String:Any]
            var testuser:Room
            
            
            // print("RoomID : \(roomID)")
            let rname = roomData!["Name"]
            //print("Room Name : \(rname!)")
            let rdesc = roomData!["Description"]
            // print("Room Description : \(rdesc!)")
            let ownerID = roomData!["OwnerID"]
            // print("Owner : \(ownerID!)")
            
            
            
            
            let locationList = roomData!["LocationList"] as? NSArray
            var tempLocationsList:[Location] = []
            for x in locationList!
            {
                let location = x as? [String:Any]
                
                let lname = location!["Name"]
                //print("Name of location : \(lname!)")
                let ldesc = location!["Description"]
                //print("Description of location : \(ldesc!)")
                let lat = location!["Latitude"]
                //print("Latitude : \(lat!)")
                let long = location!["Longitude"]
                //print("Longitude : \(long!)")
                let commentList = location!["CommentList"] as? NSArray
                
                
                var tempCommentList:[Comment] = []
                //var count = 1
                for y in commentList!
                {
                    let commentData = y as? [String:Any]
                    let comment = commentData!["Comment"]
                    let commentUsername = commentData!["Username"]
                    tempCommentList.append(Comment(username: String(describing:commentUsername!), comment: String(describing:    comment!)))
                }
                
                tempLocationsList.append(Location(name: String(describing: lname!), description: String(describing: ldesc!), latitiude: String(describing: lat!), longitude: String(describing: long!), commentList: tempCommentList))
                
            }
            let memberList = roomData!["Members"] as? NSArray
            var mcount = 1
            var tempMemberList:[String] = []
            for member in memberList!
            {
                tempMemberList.append(String(describing: member))
                mcount += 1
            }
            testuser = Room(name: String(describing: rname!), description: String(describing: rdesc!), ownerID: String(describing: ownerID!), locationList: tempLocationsList, memberList: tempMemberList)
            self.appDelegate.roomList.append(testuser)
            print(testuser.LocationList[0].Name)
        })
    }
    
}

