//
//  RegisterViewController.swift
//  FoodNFriends
//
//  Created by elgin on 14/1/22.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController{
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var cfmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var dummyuser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inituser()
        passwordTxt.isSecureTextEntry = true
        cfmPasswordTxt.isSecureTextEntry = true

    }
    
    func inituser()
    {
        dummyuser = User(username: "testuser", password: "testpassword", room:[])
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if usernameTxt.text != "" || passwordTxt.text != "" || cfmPasswordTxt.text != ""
        {
            if passwordTxt.text == cfmPasswordTxt.text
            {
                if usernameTxt.text != dummyuser?.Username
                {
                    dummyuser = User(username: usernameTxt.text!, password: cfmPasswordTxt.text!, room: [])
                    AppDelegate.userName = usernameTxt.text!
                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Username Taken", message: "Please user another username", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            else
            {
                let alert = UIAlertController(title: "Password Mismatch", message: "Please input the same password", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Empty input", message: "Please enter all input", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
