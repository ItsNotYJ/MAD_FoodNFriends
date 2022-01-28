//
//  AddLocationViewController.swift
//  FoodNFriends
//
//  Created by DAVE on 27/1/22.
//

import Foundation
import MapKit

class AddLocationViewController: UIViewController , UISearchResultsUpdating{
    
    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        searchVC.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Please enter a postal code or address", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
        
        searchVC.searchBar.backgroundColor = .systemGray5
        
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultsViewController else
              {
                  return
              }
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query){ result in
            switch result {
            case .success(let places) :
                
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                print(places)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddLocationViewController:ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        
        searchVC.searchBar.resignFirstResponder()
        
        searchVC.dismiss(animated: true, completion: nil)
        
        //remove pins
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        //Add a map pin
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
    }
}
