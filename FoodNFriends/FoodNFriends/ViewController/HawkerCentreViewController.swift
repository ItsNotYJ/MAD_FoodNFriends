//
//  HawkerCentreViewController.swift
//  FoodNFriends
//
//  Created by Jae on 20/1/22.
//

import Foundation
import UIKit

class HawkerCentreViewController: UIViewController {
    @IBOutlet weak var hawkerName: UILabel!
    @IBOutlet weak var hawkerType: UILabel!
    @IBOutlet weak var hawkerAddr: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var hawkerStalls: UILabel!
    @IBOutlet weak var marketStalls: UILabel!
    
    // Use appDelegate to retrieve the selected row indexPath and use to retrieve hawker centre list data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the specific hawker object from the appDelegate list
        let hawkerCentre: HawkerCentre = appDelegate.hawkerCentreList[appDelegate.hawkerCentreIndex!]
        
        // Display all the object data onto view
        hawkerName.text = hawkerCentre.name
        if hawkerCentre.type == "HC" {
            hawkerType.text = "Hawker Centre"
        }
        else {
            hawkerType.text = "Market and Hawker Centre"
        }
        hawkerAddr.text = hawkerCentre.address
        postalCode.text = "S" + String(hawkerCentre.postalcode)
        hawkerStalls.text = String(hawkerCentre.cookedfoodstalls)
        marketStalls.text = String(hawkerCentre.mktproducestalls)
    }
}
