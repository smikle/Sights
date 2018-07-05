//
//  SightDataSource.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit
import CoreData
import MapKit

protocol SigthsDataSourceProtocol: UITableViewDataSource {
    
    var tableView: UITableView? { get set }
    
    var isEmpty: Bool { get }
    
    var items: [SightProtocol] { get }
    
    func fetch()
    func save()
    
    func item(at indexPath: IndexPath) -> SightProtocol
    func delete(at indexPath: IndexPath)
}

extension SigthsDataSourceProtocol {
    var isEmpty: Bool {
        return items.count == 0
    }
}

class SightDataSource: NSObject, SigthsDataSourceProtocol {
    
    private let cellId: String = String(describing: SightCell.self)
    weak var tableView: UITableView?
    
    private var cdManager: CoreDataManagerProtocol!
    
    private lazy var fetchedResultsController: SightsFetchedResultsControllerProtocol = SightsFetchedResultsController(manager: cdManager, delegate: self)
    
    //MARK: -
    
    init(manager: CoreDataManagerProtocol, fetchedController: SightsFetchedResultsControllerProtocol? = nil) {
        super.init()
        
        self.cdManager = manager
        if let fetchedController = fetchedController {
            fetchedResultsController = fetchedController
        }
    }

    //MARK: - SigthsDataSourceProtocol
    
    var items: [SightProtocol] {
        if let items = fetchedResultsController.objects {
            return items
        }
        
        return [SightProtocol]()
    }
    
    //MARK: - SigthsDataSourceProtocol
    
    func fetch() {
         try? fetchedResultsController.performFetch()
    }
    
    func save() {
        cdManager.saveContext()
    }
    
    func item(at indexPath: IndexPath) -> SightProtocol {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func delete(at indexPath: IndexPath) {
        guard let object = fetchedResultsController.object(at: indexPath) as? Sight else {
            return
        }
        cdManager.delete(object)
        cdManager.saveContext()
    }
    
    //MARK: - TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? SightCell else {
            return UITableViewCell()
        }
        
        let item = fetchedResultsController.object(at: indexPath)
        cell.item = item
        
        return cell
    }
}

extension SightDataSource: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .automatic)                
            }
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            
            tableView?.reloadRows(at: [indexPath], with: .automatic)
            
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
