//
//  Sight.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import CoreData

protocol SightProtocol: NSObjectProtocol {
    var name: String! { get set }
    var descr: String? { get set }
    var longitude: Double { get set }
    var latitude: Double { get set }
    var isUserPoint: Bool { get set }
    
    var distance: Int32 { get set }
    
    @discardableResult
    func save() -> Bool
    func rollback()
    
    var isFault: Bool { get }
}

@objc(Sight)
public class Sight: NSManagedObject, Decodable, SightProtocol {
    
    static let entityName: String = String(describing: Sight.self)
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sight> {
        return NSFetchRequest<Sight>(entityName: Sight.entityName)
    }
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String!
    @NSManaged public var descr: String?
    
    @NSManaged public var isUserPoint: Bool
    @NSManaged public var distance: Int32
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case name
        case descr
        case isUserPoint
    }
    
    //MARK: -
    
    convenience init(isUserPoint: Bool) {
        self.init(entity: CoreData.manager.entity(for: Sight.entityName), insertInto: CoreData.manager.persistentContainer.viewContext)
        self.name = "Your place"
        self.isUserPoint = isUserPoint
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: CoreData.manager.entity(for: Sight.entityName), insertInto: CoreData.manager.persistentContainer.viewContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        name = try values.decode(String.self, forKey: .name)
        descr = try? values.decode(String.self, forKey: .descr)
        isUserPoint = (try? values.decode(Bool.self, forKey: .isUserPoint)) ?? false
        distance = Map.engine.distance(latitude: latitude, longitude: longitude)
    }
}

extension Sight: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(name, forKey: .name)
        try container.encode(descr, forKey: .descr)
        try container.encode(isUserPoint, forKey: .isUserPoint)
    }
}

extension Sight {    
    @discardableResult
    func save() -> Bool {
        do {
            try managedObjectContext?.save()
            dPrint("changes has been saved")
            return true
        } catch {
            dPrint(error)
            return false
        }
    }
    
    func rollback() {
        managedObjectContext?.rollback()
    }
}
