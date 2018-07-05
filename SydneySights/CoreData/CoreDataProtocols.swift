//
//  CoreDataProtocols.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/4/18.
//  Copyright © 2018 SML. All rights reserved.
//

import CoreData

protocol CoreDataManagerProtocol: class {
    
    var context: NSManagedObjectContext { get }
    var hasChanges: Bool { get }
    
    func delete(_ obj: NSManagedObject)
    
    @discardableResult
    func saveContext() -> Bool
    func rollback()    
}

protocol CoreDataJSONProtocol: CoreDataManagerProtocol {
    func jsonExport() -> Data?
    func jsonImport(_ jsonData: Data?) -> Bool
}
