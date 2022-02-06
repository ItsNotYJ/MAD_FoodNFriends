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
    typealias CompletionHandler = (_ success:Bool) -> Void
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private let database = Database.database().reference()
    
    //function to load all room information from firebase using roomCode
    func loadFromFireBase(roomID : String, completionHandler: @escaping CompletionHandler) {
        database.child("Rooms").child(roomID).observeSingleEvent(of: .value, with: {snapshot in
            //retrieving snapshot information as roomData
            let roomData = snapshot.value as? [String:Any]
            var testuser:Room
            
            
            //retrieving values of name, description, ownerID and roomCode
            
            // print("RoomID : \(roomID)")
            let rname = roomData!["Name"]
            //print("Room Name : \(rname!)")
            let rdesc = roomData!["Description"]
            // print("Room Description : \(rdesc!)")
            let ownerID = roomData!["OwnerID"]
            // print("Owner : \(ownerID!)")
            let roomCode = roomData!["RoomCode"]
            
            
            
            //retrieving locationlist from roomData
            let locationList = roomData!["LocationList"] as? NSArray
            var tempLocationsList:[Location] = []
            
            //checking if locationlist is empty
            if locationList == nil
            {
                
            }
            else
            {
                for x in locationList!
                {
                    
                    //retrieving information of location
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
                    if commentList == nil
                    {
                        
                    }
                    else
                    {
                        //retrieving information of comment
                        for y in commentList!
                        {
                            let commentData = y as? [String:Any]
                            let comment = commentData!["Comment"]
                            let commentUsername = commentData!["Username"]
                            tempCommentList.append(Comment(username: String(describing:commentUsername!), comment: String(describing:    comment!)))
                        }
                        
                        
                    }
                    
                    //appending information of location to a list
                    tempLocationsList.append(Location(name: String(describing: lname!), description: String(describing: ldesc!), latitiude: String(describing: lat!), longitude: String(describing: long!), commentList: tempCommentList))
                    
                }
            }
            //retrieving information of memberlist
            let memberList = roomData!["Members"] as? NSArray
            var mcount = 1
            var tempMemberList:[String] = []
            for member in memberList!
            {
                //appending members to temporary array
                tempMemberList.append(String(describing: member))
                mcount += 1
            }
            
            //setting room information as object and appending to appDelegate
            testuser = Room(name: String(describing: rname!), description: String(describing: rdesc!), ownerID: String(describing: ownerID!), roomCode: String(describing: roomCode!), locationList: tempLocationsList, memberList: tempMemberList)
            self.appDelegate.roomList.append(testuser)
            
            completionHandler(true)
        })
    }
    
}
