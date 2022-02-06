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
    
    //initializing locationList
    var locationList:[Location] = []
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var name = ""
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        //retrieving value of locationList from appdelegate
        locationList = appDelegate.room!.LocationList
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        adressTxt.text = name
        
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        //alert popup input for description
        let alert = UIAlertController(title: "Enter location description", message: "", preferredStyle: .alert)
        
        // Set textfield to the alert view for user input
        alert.addTextField()
        
        // Retrieve textfield input
        let subAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            
            let description = alert.textFields![0]
            
            if description.text == "" {
                let validationAlert = UIAlertController(title: "Please enter a proper description", message: "", preferredStyle: .alert)
                validationAlert.addAction(UIAlertAction(title: "Exit", style: .cancel))
                
                self.present(validationAlert, animated: true)
            } else {
                // TODO: Save the description.text to firebase description attribute
                
                let newLocation = Location(name: self.name, description: description.text!, latitiude: self.lat, longitude: self.long, commentList: [])
                
                //initializint totalArray
                var totalArray:[[String:Any]] = []
                for loc in self.locationList
                {
                    let array = ["Name" : loc.Name, "Description" : loc.Description, "Latitude" : loc.Latitiude, "Longitude" : loc.Longitude, "CommentList" : loc.CommentList] as [String : Any]
                    //appending all exisitng locations to totalArray
                    totalArray.append(array)
                }
                
                //initializing newData with information from selected location
                let newData = ["Name" : newLocation.Name, "Description" : newLocation.Description, "Latitude" : newLocation.Latitiude, "Longitude" : newLocation.Longitude, "CommentList" : []] as [String : Any]
                
                //appending new location data to totalArray
                totalArray.append(newData)
                
                //appending newLocation to appDelegate
                self.appDelegate.room?.LocationList.append(newLocation)
                
                self.locationList.append(newLocation)
                
                //updating firebase information with new and existing locations
                self.database.child("Rooms").child(self.appDelegate.room!.RoomCode).child("LocationList").setValue(totalArray)
                
                //alert to prompt success message
                let alert = UIAlertController(title: "Success", message: "Location has been added!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                
                
            }
        }
        
        alert.addAction(subAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)    }

    
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
