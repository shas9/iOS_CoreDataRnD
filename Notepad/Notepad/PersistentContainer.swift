//
//  PersistentContainer.swift
//  Notepad
//
//  Created by Shahwat Hasnaine on 13/3/24.
//

import CoreData

class PersistentContainer {
    static let shared = PersistentContainer()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Could not load Core Data persistence sotres. Error: \(error)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Could not load Core Data persistence sotres. Error: \(error)")
            }
        }
    }
    
    func saveChanges() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Could not save changes to Core Data. Error: \(error)")
            }
        }
    }
}
