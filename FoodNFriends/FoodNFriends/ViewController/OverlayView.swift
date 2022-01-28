//
//  OverlayView.swift
//  FoodNFriends
//
//  Created by Dave on 28/1/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class OverlayView: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let database = Database.database().reference()
    
    var locationList:[Location] = []
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var name = ""
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationList = appDelegate.room!.LocationList
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        adressTxt.text = name
        
    }
    
    @IBAction func addBtn(_ sender: Any) {
        let desc = descriptionTxt.text!
        
        let newLocation = Location(name: name, description: desc, latitiude: lat, longitude: long, commentList: [])
        
        var totalArray:[[String:Any]] = []
        for loc in locationList
        {
            let array = ["Name" : loc.Name, "Description" : loc.Description, "Latitude" : loc.Latitiude, "Longitude" : loc.Longitude, "CommentList" : loc.CommentList] as [String : Any]
            
            totalArray.append(array)
        }
        
        let newData = ["Name" : newLocation.Name, "Description" : newLocation.Description, "Latitude" : newLocation.Latitiude, "Longitude" : newLocation.Longitude, "CommentList" : []] as [String : Any]
        
        totalArray.append(newData)
        
        
        appDelegate.room?.LocationList.append(newLocation)
        
        locationList.append(newLocation)
        
        database.child("Rooms").child(appDelegate.room!.RoomCode).child("LocationList").setValue(totalArray)
        
        let alert = UIAlertController(title: "Success", message: "Location has been added!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

    
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var adressTxt: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x:0, y:self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
