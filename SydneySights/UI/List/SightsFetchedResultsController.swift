//
//  SightsFetchedResultsController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/5/18.
//  Copyright © 2018 SMiLe. All rights reserved.
//

import CoreData

protocol SightsFetchedResultsControllerProtocol {
    var objects: [SightProtocol]? { get }
    var sections: [NSFetchedResultsSectionInfo]? { get }

    func performFetch() throws
    func object(at indexPath: IndexPath) -> SightProtocol
}

class SightsFetchedResultsController: NSFetchedResultsController<Sight>, SightsFetchedResultsControllerProtocol {
    
    init(manager: CoreDataManagerProtocol, delegate: NSFetchedResultsControllerDelegate) {
        let fetchRequest: NSFetchRequest<Sight> = Sight.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        super.init(fetchRequest: fetchRequest, managedObjectContext: manager.context, sectionNameKeyPath: nil, cacheName: nil)

        self.delegate = delegate
    }
    
    func object(at indexPath: IndexPath) -> SightProtocol {
        return super.object(at: indexPath)
    }
    
    var objects: [SightProtocol]? {
        return fetchedObjects
    }
}
