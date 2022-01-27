//
//  FirebaseDAL.swift
//  FoodNFriends
//
//  Created by MAD2 on 24/1/22.
//

import Foundation
import FirebaseDatabase
import UIKit

class FirebaseDAL
{
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private let database = Database.database().reference()
    
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
            
        })
    }
    
}
