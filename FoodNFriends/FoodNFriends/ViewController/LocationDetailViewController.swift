//
//  LocationDetailViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 24/1/22.
//

import Foundation
import UIKit

class LocationDetailViewController : UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var location:Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = appDelegate.location
        
        nameTxt.text = location?.Name
        descTxt.text = location?.Description
        latTxt.text = location?.Latitiude
        longTxt.text = location?.Longitude
    }
    
    
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var descTxt: UILabel!
    @IBOutlet weak var latTxt: UILabel!
    @IBOutlet weak var longTxt: UILabel!
    
}

