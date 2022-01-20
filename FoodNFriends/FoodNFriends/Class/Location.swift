//
//  Location.swift
//  FoodNFriends
//
//  Created by MAD2 on 20/1/22.
//

import Foundation
class Location {
    var Name:String
    var Description:String
    var Latitiude:String
    var Longitude:String
    var CommentList:[Comment] = []

    init(name:String, description:String, latitiude:String, longitude:String, commentList:[Comment])
    {
        Name = name
        Description = description
        Latitiude = latitiude
        Longitude = longitude
        CommentList = commentList
    }

}
