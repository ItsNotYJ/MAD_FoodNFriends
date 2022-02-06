//
//  Room.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation

//room class to store information of room and list of locations
class Room {
    var Name:String
    var Description:String
    var OwnerID:String
    var RoomCode:String
    
    //list of locations
    var LocationList:[Location] = []
    //list of memberID
    var MemberList:[String] = []

    init(name:String, description:String, ownerID:String, roomCode:String, locationList:[Location], memberList:[String])
    {
        Name = name
        Description = description
        OwnerID = ownerID
        RoomCode = roomCode
        LocationList = locationList
        MemberList = memberList
    }

}
