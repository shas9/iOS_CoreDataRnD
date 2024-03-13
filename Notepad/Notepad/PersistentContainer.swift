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
    
    func create(title: String, body: String, isFavorite: Bool) {
        let entity = Note(context: container.viewContext)
        
        entity.id = UUID()
        entity.title = title
        entity.body = body
        entity.isFavorite = isFavorite
        entity.createdAt = Date()
        
        saveChanges()
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) ->[Note] {
        // For saving fetched notes
        var results: [Note] = []
        
        // Init fetch request
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        // define filter && || limit if needed
        if let predicateFormat {
            request.predicate = NSPredicate(format: predicateFormat)
        }
        
        if let fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        // Perform fetch with request
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            fatalError("Could not fetch notes from Core Data. Error: \(error)")
        }
        
        return results
    }
    
    func update(entity: Note, title: String? = nil, body: String? = nil, isFavorite: Bool? = nil) {
        var hasChanges: Bool = false
        
        if let title {
            entity.title = title
            hasChanges = true
        }
        
        if let body {
            entity.body = body
            hasChanges = true
        }
        
        if let isFavorite {
            entity.isFavorite = isFavorite
            hasChanges = true
        }
        
        if hasChanges {
            saveChanges()
        }
    }
    
    func delete(entity: Note) {
        container.viewContext.delete(entity)
        saveChanges()
    }
}
