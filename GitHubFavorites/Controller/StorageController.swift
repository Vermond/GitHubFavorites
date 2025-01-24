//
//  StorageController.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import CoreData

class StorageController {
    static let shared = StorageController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleUserData")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createUserData(userId: Int64, name: String, imgPath: String) {
        let context = self.context
        
        let data = UserData(context: context)
        data.userId = userId
        data.userName = name
        data.imgPath = imgPath
        
        do {
            try context.save()
        } catch {
            print("Failed to create user data: \(error.localizedDescription)")
        }
    }
    
    func fetchUserData() -> [UserData] {
        let context = self.context
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUserData(withId userId: Int64) -> [UserData] {
        let context = self.context
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        request.predicate = NSPredicate(format: "userId == %d", userId)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUserData(withName userName: String) -> [UserData] {
        let context = self.context
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS %@", userName)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteUserData(userData: UserData) {
        let context = self.context
        context.delete(userData)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete user data: \(error.localizedDescription)")
        }
    }
}
