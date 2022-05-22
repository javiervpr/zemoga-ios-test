//
//  UserService.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import CoreData

class UserService {
    
    var storeManager: StoreManager
    
    init(storeManager: StoreManager) {
        self.storeManager = storeManager
    }
    
    func save(id: Int, name: String, email: String, phone: String, web: String) -> User {
        let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: storeManager.persistentContainer.viewContext) as! User
        user.id = Int64(id)
        user.name = name
        user.email = email
        user.phone = phone
        user.website = web
        return user
    }
    
    func fetchAll() -> [User] {
        let fetchUser = NSFetchRequest<User>(entityName: User.entityName)
        fetchUser.sortDescriptors = [ NSSortDescriptor(key: #keyPath(User.name), ascending: true) ]
        do {
            return try storeManager.persistentContainer.viewContext.fetch(fetchUser)
            
        } catch {
            fatalError("Error fetching users")
        }
    }
    
    func fetchUserById(userId: Int) -> User? {
        let fecthUser = NSFetchRequest<User>(entityName: User.entityName)
        fecthUser.predicate = NSPredicate(format: "id == %ld", userId)
        do {
            let result = try storeManager.persistentContainer.viewContext.fetch(fecthUser)
            if (result.isEmpty) {
                return nil
            } else {
                return result.first
            }
            
        } catch {
            fatalError("Error fetching user")
        }
    }
    
    func delete(user: User) {
        storeManager.persistentContainer.viewContext.delete(user)
    }
}
