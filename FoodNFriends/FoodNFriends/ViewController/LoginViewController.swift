//
//  LoginViewController.swift
//  FoodNFriends
//
//  Created by elgin on 13/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    private let database = Database.database().reference()
    
    let fireBase:FirebaseDAL = FirebaseDAL()
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Code to design the view to make it look better
        loginBtn.layer.cornerRadius = 22
        emailTxt.layer.cornerRadius = 22
        passwordTxt.layer.cornerRadius = 22
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        /*
        var test = ["user1","user2","elginloh-gmail_com","dave21sg-gmail_com"]
        let databaseRef = Database.database().reference()
        databaseRef.child("Rooms").child("room1").child("Members").setValue(test)
        */
        
        passwordTxt.isSecureTextEntry = true
    }
    
    // UITextfield methods to close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Change the behaviour of the iOS keyboard
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        return true
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
                
                let email = self.emailTxt.text!
                let emailnew = email.replacingOccurrences(of: "@", with: "-")
                let emailnewer = emailnew.replacingOccurrences(of: ".", with: "_")
                
                
                AppDelegate.emailRef = self.emailTxt.text!
                
                
                
                var roomIDList:[String] = []
                
                
                
                self.database.child("Users").child(emailnewer).observeSingleEvent(of: .value, with: {snapshot in
                    let userData = snapshot.value as? [String:Any]
                    
                    
                    
                    
                    if userData!["RoomList"] == nil {
                        print("error")
                    }
                    else
                    {
                        let roomlist = userData!["RoomList"] as! NSArray
                        
                        
                        for roomid in roomlist
                        {
                            
                            roomIDList.append((roomid as? String)!)
                        }
                        
                    }
                    
                    for roomid in roomIDList
                    {
                        self.fireBase.loadFromFireBase(roomID: roomid,completionHandler: { (success) -> Void in
                            if success {
                                
                            }
                            else
                            {
                                print("error")
                            }
                        })
                    }
                })
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Loading") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            })
        }
    }
    
}

