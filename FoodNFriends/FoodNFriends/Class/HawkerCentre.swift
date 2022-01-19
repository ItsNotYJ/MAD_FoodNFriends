//
//  HawkerCentre.swift
//  FoodNFriends
//
//  Created by Jae on 19/1/22.
//

import Foundation

struct HawkerCentre: Codable {
    var name: String
    var type: String
    var owner: String
    var stalls: Int
    var cookedfoodstalls: Int
    var mktproducestalls: Int
    var address: String
    var postalcode: Int
    var city: String
    var country: String
    var lat: Double
    var lng: Double
}

class HawkerApi {
    // Retrieve Hawker Centre API Data function
    func GetHawkerCentres(completion: @escaping ([HawkerCentre]) -> ()) {
        // Set API url
        // If url is not URL, stop and return
        guard let url = URL(string: "https://api.jael.ee/datasets/hawker") else { return }
        
        // Prepare URL session to call API
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            // Have to take note of request time out errors (May be due to internet connection)
            
            // TODO: Validation of API Requests (Guard and Try Catch)
            let hawkerCentres = try! JSONDecoder().decode([HawkerCentre].self, from: data!)
            
            // Run the completion handler in the background thread so that it does not disrupt the loading of the View UI on the main thread, hence "async".
            DispatchQueue.main.async {
                completion(hawkerCentres)
            }
        }
        .resume()
        // Starts the dataTask call
    }
}
