//
//  HawkerCentreViewController.swift
//  FoodNFriends
//
//  Created by Jae on 20/1/22.
//

import Foundation
import UIKit
import GoogleMaps
import FirebaseDatabase

class HawkerCentreViewController: UIViewController {
    @IBOutlet weak var hawkerName: UILabel!
    @IBOutlet weak var hawkerType: UILabel!
    @IBOutlet weak var hawkerAddr: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var hawkerStalls: UILabel!
    @IBOutlet weak var marketStalls: UILabel!
    @IBOutlet weak var hawkerCentreMapView: GMSMapView!
    
    // Use appDelegate to retrieve the selected row indexPath and use to retrieve hawker centre list data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hawkerCentre: HawkerCentre?
    var locationList:[Location] = []
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        // Retrieve the specific hawker object from the appDelegate list
        hawkerCentre = appDelegate.hawkerCentreList[appDelegate.hawkerCentreIndex!]
        
        // Create a GMSCameraPosition that tells the map to display the hawker centre location based on its longitude and latitude
        hawkerCentreMapView.camera = GMSCameraPosition.camera(withLatitude: hawkerCentre!.lat, longitude: hawkerCentre!.lng, zoom: 15, bearing: 0, viewingAngle: 0)
        
        if appDelegate.mapType == "normal" {
            hawkerCentreMapView.mapType = .normal
        } else if appDelegate.mapType == "hybrid" {
            hawkerCentreMapView.mapType = .hybrid
        } else {
            hawkerCentreMapView.mapType = .terrain
        }
        
        hawkerCentreMapView.animate(toViewingAngle: 20)
        
        // Create a marker in the center of the map to show the location of the hawker centre.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: hawkerCentre!.lat, longitude: hawkerCentre!.lng)
        marker.title = hawkerCentre!.name
        marker.snippet = hawkerCentre!.address
        marker.icon = GMSMarker.markerImage(with: .purple)
        marker.map = hawkerCentreMapView
        
        // Display all the object data onto view
        hawkerName.text = hawkerCentre!.name
        if hawkerCentre!.type == "HC" {
            hawkerType.text = "Hawker Centre"
        }
        else {
            hawkerType.text = "Market and Hawker Centre"
        }
        
        hawkerAddr.text = hawkerCentre!.address
        postalCode.text = "S" + String(hawkerCentre!.postalcode)
        hawkerStalls.text = String(hawkerCentre!.cookedfoodstalls)
        marketStalls.text = String(hawkerCentre!.mktproducestalls)
    }
    
    @IBAction func addLocation(_ sender: Any) {
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
                
                let newLocation = Location(name: self.hawkerCentre!.address, description: description.text!, latitiude: String(self.hawkerCentre!.lat), longitude: String(self.hawkerCentre!.lng), commentList: [])
                
                var totalArray:[[String:Any]] = []
                for loc in self.locationList
                {
                    let array = ["Name" : loc.Name, "Description" : loc.Description, "Latitude" : loc.Latitiude, "Longitude" : loc.Longitude, "CommentList" : loc.CommentList] as [String : Any]
                    
                    totalArray.append(array)
                }
                
                let newData = ["Name" : newLocation.Name, "Description" : newLocation.Description, "Latitude" : newLocation.Latitiude, "Longitude" : newLocation.Longitude, "CommentList" : []] as [String : Any]
                
                totalArray.append(newData)
                
                
                self.appDelegate.room?.LocationList.append(newLocation)
                
                self.locationList.append(newLocation)
                
                self.database.child("Rooms").child(self.appDelegate.room!.RoomCode).child("LocationList").setValue(totalArray)
                
                let alert = UIAlertController(title: "Success", message: "Location has been added!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                    
                }))
                self.present(alert, animated: true)
                
                
            }
        }
        
        alert.addAction(subAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
