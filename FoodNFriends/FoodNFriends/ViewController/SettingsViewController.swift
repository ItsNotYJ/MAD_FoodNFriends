//
//  SettingsViewController.swift
//  FoodNFriends
//
//  Created by elgin on 20/1/22.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerViewBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let scrWidth = UIScreen.main.bounds.width - 10
    let scrHeight = UIScreen.main.bounds.height / 2
    var selRow = 0
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutBtn.layer.cornerRadius = 22
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.borderColor = .init(red: 223, green: 78, blue: 50, alpha: 1)
        
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .dark
    }
    
    var mapTypes: KeyValuePairs = [
        "Default": "normal",
        "Terrain": "terrain",
        "Hybrid": "hybrid"
    ]
    
    @IBAction func popupPicker(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: scrWidth, height: scrHeight)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: scrWidth, height: scrHeight))
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Map Type", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = pickerViewBtn
        alert.popoverPresentationController?.sourceRect = pickerViewBtn.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in }))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { UIAlertAction in
            self.selRow = pickerView.selectedRow(inComponent: 0)
            
            let selected = Array(self.mapTypes)[self.selRow]
            let name = selected.value
            let type = selected.key
            
            // TODO: Save the settings to firebase storage so that it can be loaded when the user returns
            self.appDelegate.mapType = name
            self.pickerViewBtn.setTitle(type, for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mapTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: scrWidth, height: 30))
        label.text = Array(mapTypes)[row].key
        label.sizeToFit()
        return label
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            appDelegate.hawkerCentreList = []
            appDelegate.roomList = []
            AppDelegate.emailRef = ""
            
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "An error occurred", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
}
