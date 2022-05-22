//
//  MockPersistantContainer.swift
//  ZemogaMobileTests
//
//  Created by Luci on 20/5/22.
//

import CoreData

class MockPersistantContainer {
 
    /**
     lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "ZemogaMobile")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                  application, although it may be useful during development.
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()
     
     */
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ZemogaMobile")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )

            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
}
