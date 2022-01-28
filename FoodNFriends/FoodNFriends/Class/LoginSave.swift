//
//  Login.swift
//  FoodNFriends
//
//  Created by Jae on 28/1/22.
//

import Foundation

class LoginSave {
    var email: String?
    var isChecked: Bool?
    
    init (e: String, isChk: Bool) {
        self.isChecked = isChk
        self.email = e
    }
}
