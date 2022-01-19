//
//  LoginViewController.swift
//  FoodNFriends
//
//  Created by elgin on 13/1/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    var dummyuser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTxt.isSecureTextEntry = true
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        if emailTxt.text == "" || passwordTxt.text == ""
        {
            let alert = UIAlertController(title: "Empty input", message: "Please enter all input", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { result, error in
                
                guard error == nil else {
                    //fail to sign in
                    let alert = UIAlertController(title: "Incorrect Username/Password", message: "Please try again", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                AppDelegate.emailRef = self.emailTxt.text!
                let storyboard = UIStoryboard(name: "Content", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            })
        }
        /*
        if emailTxt.text == dummyuser!.Username && passwordTxt.text == dummyuser!.Password
        {
            AppDelegate.emailRef = emailTxt.text!
            let storyboard = UIStoryboard(name: "Content", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Wrong Username/Password", message: "Please try again", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
         */
    }
}

