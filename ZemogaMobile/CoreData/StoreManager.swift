//
//  StoreManager.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import UIKit
import CoreData

class StoreManager {
    let persistentContainer: NSPersistentContainer!

    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

