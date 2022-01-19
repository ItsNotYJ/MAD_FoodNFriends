//
//  LoginViewController.swift
//  FoodNFriends
//
//  Created by elgin on 13/1/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    var dummyuser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTxt.isSecureTextEntry = true
        inituser()
    }
    
    func inituser()
    {
        dummyuser = User(username: "testuser", password: "testpassword", room:[])
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if usernameTxt.text == dummyuser!.Username && passwordTxt.text == dummyuser!.Password
        {
            AppDelegate.userName = usernameTxt.text!
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
    }
}

