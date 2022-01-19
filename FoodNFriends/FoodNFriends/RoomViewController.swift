//
//  RoomViewController.swift
//  FoodNFriends
//
//  Created by elgin on 14/1/22.
//

import Foundation
import UIKit

class RoomViewController : UIViewController {
    

    @IBOutlet weak var labelTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTxt.text = AppDelegate.userName
    }
    
}
