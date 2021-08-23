//
//  DatabaseHelper.swift
//  LogInFlow
//
//  Created by Macbook on 19/08/2021.
//

import UIKit
import CoreData

class DatabaseHelper{
    static let shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveUser(userModel:UserModel){
        if let context = context{
            let user = User(context:context)
            user.fname = userModel.fname
            user.lname = userModel.lname
            user.email = userModel.email
            user.password = userModel.password
            user.imagePath = userModel.imagePath
            
        }
        saveContext()
        
        
    }
    func updateUser(userModel: UserModel, user: User){
        user.fname = userModel.fname
        user.lname = userModel.lname
        user.email = userModel.email
        user.password = userModel.password
        user.imagePath = userModel.imagePath
        saveContext()
    }
    func getAllUsers() -> [User]{
        var arrUsers = [User]()
        if let context = context{
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do{
                try arrUsers = context.fetch(fetchRequest) as! [User]
            }catch{
                print(error.localizedDescription)
            }
        }
        return arrUsers
        
    }
    
    
    func saveContext(){
        if let context = context{
            do{
                try context.save()
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
}


