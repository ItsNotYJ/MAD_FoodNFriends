//
//  SettingsViewController.swift
//  FoodNFriends
//
//  Created by elgin on 20/1/22.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "An error occurred", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
}
