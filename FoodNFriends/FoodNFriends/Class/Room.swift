//
//  Room.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation
class Room {
    var Name:String
    var Description:String
    var OwnerID:String
    var RoomCode:String
    var LocationList:[Location] = []
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
