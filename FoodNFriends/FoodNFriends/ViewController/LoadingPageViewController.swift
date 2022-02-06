//
//  LoadingPageViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 27/1/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingPageViewController: UIViewController {
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicatorView.type = .ballScaleRippleMultiple
        loadingIndicatorView.color = .white
        loadingIndicatorView.startAnimating()
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
        
        //setting fixed delay to stay ono loading page
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.loadingIndicatorView.stopAnimating()
            //redirect to content view
            let storyboard = UIStoryboard(name: "Content", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}
