//
//  User.swift
//  FoodNFriends
//
//  Created by elgin on 13/1/22.
//

import Foundation

class User {
    var Username:String
    var Password:String
    var Room:[String] = []

    init(username:String, password:String, room:[String])
    {
        Username = username
        Password = password
        Room = room
    }

}
