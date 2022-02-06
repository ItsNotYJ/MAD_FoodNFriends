//
//  ResultsViewController.swift
//  FoodNFriends
//
//  Created by Dave on 27/1/22.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: CLLocationCoordinate2D)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    weak var delegate: ResultsViewControllerDelegate?
    private let tableView: UITableView = {
        //setting UITableView in controller
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "AddLocationCell")
        return table
    }()
    
    private var places:[Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        tableView.frame = view.bounds
    }
    
    public func update(with places:[Place]) {
        //retrieving data for table
        self.tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell", for:indexPath)
        //setting valuye of cell to be name of place
        
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        var long:String = ""
        var lat:String = ""
        var name:String = ""
        let place = places[indexPath.row]
        let slideVC = OverlayView()
        
        //retrieving coordinates of selected place
        GooglePlacesManager.shared.resolveLocation(for: place) {
            [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate)
                    
                }
                
                
                //retrieving latitude and longitude of placec
                
                lat = String(coordinate.latitude)
                long = String(coordinate.longitude)
                
                name = self!.places[indexPath.row].name
                
                slideVC.name = name
                
                slideVC.lat = lat
                
                slideVC.long = long
                
            case .failure(let error):
                print(error)
            }
            
            //redirecting
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self

            self!.present(slideVC, animated: true, completion: nil)
        }
        
        
    
        
        
        
       
            
            
    
        
        
    }
    

    

}

extension ResultsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
