//
//  LoginSaveController.swift
//  FoodNFriends
//
//  Created by Jae on 28/1/22.
//

import Foundation
import UIKit
import CoreData

// Login Save CRUD
class LoginSaveController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Add login save to Core Data
    func AddLoginSave(newLoginSave: LoginSave)
    {
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CDLogin", in: context)!
        
        let contact = NSManagedObject(entity: entity, insertInto: context)
        contact.setValue(newLoginSave.email, forKeyPath: "email")
        contact.setValue(newLoginSave.isChecked, forKeyPath: "isChecked")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Retrieve Login Save object from Core Data
    func RetrieveLoginSave() -> LoginSave
    {
        var fetchLoginSave:[NSManagedObject] = []
        var selLogin: LoginSave?
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDLogin")
        do {
            fetchLoginSave = try context.fetch(fetchRequest)
            let email = fetchLoginSave[0].value(forKey: "email") as? String ?? ""
            let isChecked = fetchLoginSave[0].value(forKey: "isChecked") as? Bool ?? false
            
            selLogin = LoginSave(e: email, isChk: isChecked)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return selLogin!
    }
    
    // Update login save with new information
    // Fetch data based on "email"
    func updateLoginSave(email: String, isChked: Bool) {
        var fetchLoginSave:[NSManagedObject] = []
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDLogin")
        
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            fetchLoginSave = try context.fetch(fetchRequest)
            let selLoginSave = fetchLoginSave[0] as! CDLogin
            
            selLoginSave.email = email
            selLoginSave.isChecked = isChked
            
            try context.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func IfLoginSaveIsEmpty() -> Bool
    {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDLogin")

        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                print("data not exist")
                return true
            } else {
                print("data exist")
                return false
            }
        } catch {
            print(error)
        }
        
        return false
    }
}
