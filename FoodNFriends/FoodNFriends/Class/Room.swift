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
    var LocationList:[Location] = []
    var MemberList:[String] = []

    init(name:String, description:String, ownerID:String, locationList:[Location], memberList:[String])
    {
        Name = name
        Description = description
        OwnerID = ownerID
        LocationList = locationList
        MemberList = memberList
    }

}
