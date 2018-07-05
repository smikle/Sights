//
//  CoreData.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import CoreData

class CoreData: CoreDataManagerProtocol {
    
    static private let containerName = "SydneySights"
    static let manager = CoreData()
    
    var hasChanges: Bool {
        return context.hasChanges
    }
    
    private init() { }
    
    //MARK: - Entity for Name
    
    func entity(for entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
    
    //MARK: -
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreData.containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error as NSError? else {
                return
            }
            
            dPrint(storeDescription)
            dPrint(error)
        })
        
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    //MARK: -
    
    func delete(_ obj: NSManagedObject) {
        context.delete(obj)
    }
    
    // MARK: -
    
    @discardableResult
    func saveContext() -> Bool {
        if !context.hasChanges {
            dPrint("no changes")
            return true
        }
        do {
            dPrint(context)
            try context.save()
            dPrint("changes has been saved")
            return true
        } catch {
            dPrint(error)
            return false
        }
    }
    
    func rollback() {
        context.rollback()
    }
}

extension CoreData: CoreDataJSONProtocol {
    func jsonExport() -> Data? {
        let request: NSFetchRequest<Sight> = Sight.fetchRequest()
        let sights = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? sights.performFetch()
        do {
            let data = try JSONEncoder().encode(sights.fetchedObjects)
            return data
        } catch {
            dPrint(error)
            return nil
        }
    }
    
    @discardableResult
    func jsonImport(_ jsonData: Data?) -> Bool {
        guard let data = jsonData,
            let objects = try? JSONDecoder().decode([Sight].self, from: data) else {
                return false
        }
        
        dPrint(objects)
        CoreData.manager.saveContext()
        
        return true
    }
}
