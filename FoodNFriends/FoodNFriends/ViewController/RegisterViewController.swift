//
//  RegisterViewController.swift
//  FoodNFriends
//
//  Created by elgin on 14/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController{
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    private let database = Database.database().reference()
    
    let fireBase:FirebaseDAL = FirebaseDAL()
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var cfmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
        cfmPasswordTxt.isSecureTextEntry = true
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        //checks if all input is filled
        if usernameTxt.text == "" || emailTxt.text == "" || passwordTxt.text == "" || cfmPasswordTxt.text == ""
        {
            let alert = UIAlertController(title: "Empty input", message: "Please enter all input", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            //checks if the password matches
            if passwordTxt.text == cfmPasswordTxt.text
            {
                //make sure the password is above or equal to 6 characters
                if passwordTxt.text!.count >= 6
                {
                    //create an account based on the email and password
                    FirebaseAuth.Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:{ result, error in
                        guard error == nil else {
                            let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            return
                        }
                        //replacing email characters
                        let email = self.emailTxt.text!
                        let emailnew = email.replacingOccurrences(of: "@", with: "-")
                        let emailnewer = emailnew.replacingOccurrences(of: ".", with: "_")
                        
                        //creating dictionary for firebase
                        let Users : [String : String] = ["Username" : self.usernameTxt.text!]
                        
                        let databaseRef = Database.database().reference()
                        databaseRef.child("Users").child(emailnewer).setValue(Users)
                        let alert = UIAlertController(title: "Account Created Successfully", message: "Welcome to FoodNFriends", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Continue  ", style: .default, handler: {(action:UIAlertAction) in
                            AppDelegate.emailRef = self.emailTxt.text!
                            let storyboard = UIStoryboard(name: "Content", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                            vc.modalPresentationStyle = .fullScreen
                            
                            
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
                                            print("yey")
                                        }
                                        else
                                        {
                                            print("lmao")
                                        }
                                    })
                                }
                            })
                            self.present(vc, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true)
                        
                    })
                }
                else
                {
                    let alert = UIAlertController(title: "Weak Password", message: "Please use a password that is more than 6 characters", preferredStyle: .alert)

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
        /*if usernameTxt.text != "" || passwordTxt.text != "" || cfmPasswordTxt.text != ""
        {
            if passwordTxt.text == cfmPasswordTxt.text
            {
                if usernameTxt.text != dummyuser?.Username
                {
                    dummyuser = User(username: usernameTxt.text!, password: cfmPasswordTxt.text!, room: [])
                    AppDelegate.emailRef = usernameTxt.text!
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
         */
    }
}
