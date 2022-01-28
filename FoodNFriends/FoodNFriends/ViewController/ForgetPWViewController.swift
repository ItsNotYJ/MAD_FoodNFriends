//
//  ForgetPWViewController.swift
//  FoodNFriends
//
//  Created by elgin on 27/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgetPWViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTxt.delegate = self
        
        // Code to design the view
        emailTxt.layer.cornerRadius = 22
        resetPasswordBtn.layer.cornerRadius = 22
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Change the behaviour of the iOS keyboard
        emailTxt.resignFirstResponder()
        
        return true
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailTxt.text!) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            let alert = UIAlertController(title: "Success", message: "A password reset has been sent to your email", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
