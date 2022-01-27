//
//  LoadingPageViewController.swift
//  FoodNFriends
//
//  Created by MAD2 on 27/1/22.
//

import Foundation
import UIKit


class LoadingPageViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            let storyboard = UIStoryboard(name: "Content", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}
