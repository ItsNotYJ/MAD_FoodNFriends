//
//  DirectionViewController.swift
//  FoodNFriends
//
//  Created by Jae on 27/1/22.
//

import Foundation
import UIKit

// Enables the use of Google SDK features within the iOS application
import GoogleMaps

// Used to assist in sending the API request
import Alamofire

// Used to parse JSON return objects from the API
import SwiftyJSON

class DirectionViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var directionMapView: GMSMapView!
    @IBOutlet weak var destinationName: UILabel!
    
    // Set the location manager client object
    let locationManager : CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var location: Location?
   
    // TODO: Create a dropdown list for the modeOfTransport
    var destination: String?
    var modeOfTransport: String = "driving"
 
    // Temporarily stores the json location data
    var destLatLong: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set destination location to local location variable
        location = appDelegate.location
        locationManager.delegate = self
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        // TODO: Need to change back to location!.Name, currently used for testing purposes
        var destination: String = location!.Description
        destination = destination.replacingOccurrences(of: " ", with: "")
        destinationName.text = "Directions to \(location!.Description)"
        
        // Set the user's location as a marker based on the most accurate reading of coordinates
        // Use user's location to move the camera to his/her current position on the map
        directionMapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0), zoom: 11.3, bearing: 0, viewingAngle: 0)
        
        if appDelegate.mapType == "normal" {
            directionMapView.mapType = .normal
        } else if appDelegate.mapType == "hybrid" {
            directionMapView.mapType = .hybrid
        } else {
            directionMapView.mapType = .terrain
        }
        
        // TODO: Make it so that if I put it within didUpdateLocations, only add the market once (Maybe remove old and add new and can change the colour of marker so that it can be differentiated)
        // Create a Google Maps market object for the user location
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0)
        
        marker.title = "Current location"
        marker.map = directionMapView
        
        // Ask user for permission to use his / her location
        if CLLocationManager.locationServicesEnabled() {
            // If enabled retrieve user's location
            locationManager.requestLocation()
            
            // This block of code will only run if the user's location services are enabled!
            // The route
            // Variables are the user's origin location
            let originLat = locationManager.location?.coordinate.latitude
            let originLong = locationManager.location?.coordinate.longitude
            
            // Variables are the user's destination location
            // Set to 0 as default value as validation
            var destLat: CLLocationDegrees = 0.0
            var destLong: CLLocationDegrees = 0.0
            
            let apiUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=geometry&input=\(destination)&inputtype=textquery&key=AIzaSyDAjkUdoWk_ByT4n0TnnOxAL2nf97iRQQY"
            
            // TODO: Shift the two API calls into their own seperate functions to keep the view clean
            // Using Alamofire cocoapods to do the API request
            AF.request(apiUrl).responseJSON { (response) in
                guard let jsonData = response.data else { return }
                
                // Loop through the json data structure to reach the child node required which is location within the location child node, store the longitutde and latitude of the destination and set a marker of the destination on the map
                do {
                    if let mapData = try? JSON(data: jsonData) {
                        for candidates in mapData["candidates"].arrayValue {
                            for location in candidates {
                                for jLatLong in location.1 {
                                    if jLatLong.0.description == "location" {
                                        self.destLatLong = jLatLong.1
                                        
                                        // Retrieve values of the longitude and latitude and set validation if is null to 0.0 as default values
                                        destLat = self.destLatLong.dictionaryValue["lat"]?.doubleValue ?? 0.0
                                        destLong = self.destLatLong.dictionaryValue["lng"]?.doubleValue ?? 0.0
  
                                        // Create a Google Maps market object for the destination location
                                        let marker = GMSMarker()
                                        marker.position = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
                                        marker.title = self.destinationName.text
                                        marker.map = self.directionMapView
                                        
                                        // Call the directions API to retrieve the directions between the two locations
                                        if destLat != 0.0 {
                                            // This is the directions API url and all its input parameters specified
                                            let directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?destination=\(destLat),\(destLong)&origin=\(originLat ?? 0.0),\(originLong ?? 0.0 )&mode=\(self.modeOfTransport)&key=AIzaSyDAjkUdoWk_ByT4n0TnnOxAL2nf97iRQQY"
                                            
                                            AF.request(directionsUrl).responseJSON { (dirResponse) in
                                                guard let dirJsonResponse = dirResponse.data else { return }
                                                
                                                do {
                                                    let dirMapData = try JSON(data: dirJsonResponse)
                                                        
                                                    let listOfRoutes = dirMapData["routes"].arrayValue
                                                    
                                                    // Route that is being built will contain 4 main components.
                                                    // Overview polylines, Points, Path and Polylines
                                                    for route in listOfRoutes {
                                                        let overView = route["overview_polyline"].dictionary
                                                        
                                                        let points = overView?["points"]?.string
                                                        
                                                        let paths = GMSPath.init(fromEncodedPath: points ?? "")
                                                        
                                                        let polyline = GMSPolyline.init(path: paths)
                                                        
                                                        // Slightly design and touch up the look of the polyline on the map
                                                        polyline.strokeColor = .systemPurple
                                                        polyline.strokeWidth = 5
                                                        polyline.map = self.directionMapView
                                                        
                                                        // All this will take time to load as it is a nested API call
                                                    }
                                                } catch {
                                                    print("Unable to fetch, \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // If not enabled ask for permission before retreiving
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // This function will help to retrieve the user's location and set it onto the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    
    // This function helps to determine what to do depending on what the current state of the location access is
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Switch cases help to easily swap between the different actions to be handled based on the respective location statuses
        switch manager.authorizationStatus {
            case .authorizedAlways:
                return
            case .authorizedWhenInUse:
                return
            case .denied:
                return
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // For validation and bug fixing purposes
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
