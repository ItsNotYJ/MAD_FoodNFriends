//
//  LocationDetailViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 24/1/22.
//

import Foundation
import UIKit
import GoogleMaps
import MapKit

class LocationDetailViewController : UIViewController {
    @IBOutlet weak var locationDesc: UILabel!
    @IBOutlet weak var locationAddr: UILabel!
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var directionsBtn: UIButton!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var location:Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Code to design the UI
        directionsBtn.layer.cornerRadius = 22
        directionsBtn.layer.borderWidth = 1
        directionsBtn.layer.borderColor = .init(red: 223, green: 78, blue: 50, alpha: 1)
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        // Set the selected location to local scope location variable
        location = appDelegate.location
        
        // Create a GMSCameraPosition that tells the map to display the selected location based on its longitude and latitude
        locationMapView.camera = GMSCameraPosition.camera(withLatitude: Double(location!.Latitiude)!, longitude: Double(location!.Longitude)!, zoom: 15, bearing: 0, viewingAngle: 0)
        
        if appDelegate.mapType == "normal" {
            locationMapView.mapType = .normal
        } else if appDelegate.mapType == "hybrid" {
            locationMapView.mapType = .hybrid
        } else {
            locationMapView.mapType = .terrain
        }
        
        locationMapView.animate(toViewingAngle: 20)
        
        // Create a marker in the center of the map to show the current selected location
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(location!.Latitiude)!, longitude: Double(location!.Longitude)!)
        marker.title = location?.Description
        marker.snippet = location?.Name
        marker.icon = GMSMarker.markerImage(with: .purple)
        marker.map = locationMapView
        
        // Load the text data into the view labels
        locationDesc.text = location?.Description
        locationAddr.text = location?.Name
    }
}

