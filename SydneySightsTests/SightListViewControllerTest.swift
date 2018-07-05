//
//  SightListViewControllerTest.swift
//  SydneySightsTests
//
//  Created by Mikhail Stetcura on 7/4/18.
//  Copyright © 2018 SML. All rights reserved.
//

import XCTest
import CoreData

@testable import SydneySights

class SigthsFetchedControllerTest: SightsFetchedResultsControllerProtocol {
    
    let testSights: [SightProtocol] = [SightTest(name: "USER NAME FOR SIGHT", descr: "USER DESCRIPTION FOR SIGHT", longitude: 789.012, latitude: 123.456, isUserPoint: true, distance: 123),
                                       SightTest(name: "DEFAULT NAME FOR SIGHT", descr: "DEFAULT DESCRIPTION FOR SIGHT", longitude: 89.012, latitude: 23.456, isUserPoint: false, distance: 456)]
    
    private var items = [SightProtocol]()
    
    func performFetch() throws {
        items = testSights
    }

    var objects: [SightProtocol]? {
        return items
    }
    var fetchedObjects: [SightProtocol]? {
        return items
    }
    
    var sections: [NSFetchedResultsSectionInfo]? {
        return [NSFetchedResultsSectionInfo]()
    }
    
    func object(at indexPath: IndexPath) -> SightProtocol { return items[indexPath.row] }
}

class SightListViewControllerTest: XCTestCase {
    
    let testSight: SightProtocol = SightTest(name: "USER NAME FOR SIGHT", descr: "USER DESCRIPTION FOR SIGHT", longitude: 789.012, latitude: 123.456, isUserPoint: true, distance: 123)
    var controller: SightListViewController!
    
    override func setUp() {
        super.setUp()
        controller = SightListViewController.controller() as? SightListViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTableViewDataSource() {
        _ = controller.view

        let tableView = controller.tableView
        let dataSource = controller.dataSource
        
        XCTAssertNotNil(tableView, "tableView should not be nil")
        XCTAssertNotNil(dataSource, "dataSource should not be nil")
        XCTAssertNotNil(tableView!.dataSource, "tableView.dataSource should not be nil")
        
        XCTAssertEqual(tableView, dataSource.tableView, "TableView for controller and dataSource should be Equal!")
        XCTAssert(tableView!.dataSource === dataSource, "DataSource for tableView and controller.dataSource should be Equal!")
    }
    
    func testSightCell() {
        let fetchedController = SigthsFetchedControllerTest()
        let dataSource = SightDataSource(manager: CoreData.manager, fetchedController: fetchedController)
        controller.dataSource = dataSource
        _ = controller.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell: SightCell! = controller.dataSource.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? SightCell
        
        let testSight = controller.dataSource.item(at: indexPath)
        let distanceInMeters = "\(Formatter.groupping.string(for: testSight.distance) ?? "-") m"
        
        XCTAssertEqual(cell.nameLabel.text, testSight.name, "Name field [\(cell.nameLabel.text ?? "nil")] should be equal to \(testSight.name)")
        XCTAssertEqual(cell.distanceLabel.text, distanceInMeters, "Distance field [\(cell.distanceLabel.text ?? "nil")] should be equal to \(distanceInMeters)")
    }
    
    func testEditSegue() {
        _ = controller.view
        let editController = EditViewController.controller() as? EditViewController
        
        XCTAssertNil(editController?.sight, "sight in EditViewController should be nil before set")
        
        let editSegue = UIStoryboardSegue(identifier: String(describing: EditViewController.self), source: controller, destination: editController!)
        controller.prepare(for: editSegue, sender: testSight)
        
        XCTAssertNotNil(editController?.sight, "sight in EditViewController should not be nil")
        XCTAssert(editController!.sight === testSight, "sight in EditViewController should be equal to testSight")
    }
    
    func testMapSegue() {
        let fetchedController = SigthsFetchedControllerTest()
        let dataSource = SightDataSource(manager: CoreData.manager, fetchedController: fetchedController)
        controller.dataSource = dataSource
        _ = controller.view

        let mapController = MapViewController.controller() as? MapViewController
        
        XCTAssertNil(mapController?.sights, "sights in MapViewController should be nil before set")
        
        let cell: SightCell! = controller.dataSource.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? SightCell
        
        let editSegue = UIStoryboardSegue(identifier: String(describing: MapViewController.self), source: controller, destination: mapController!)
        controller.prepare(for: editSegue, sender: cell)
        
        _ = mapController?.view
        
        XCTAssertNotNil(mapController?.sights, "sights in MapViewController should not be nil")
        XCTAssertEqual(mapController!.sights?.count, dataSource.items.count, "sight in EditViewController should be equal to testSight")
        
        XCTAssertNotNil(mapController!.startSight, "startSigth in MapViewController should not be nil")
        XCTAssert(mapController!.startSight === cell.item, "startSigth in MapViewController should be equal")
    }
    
    func testTableViewRowActions() {
        let fetchedController = SigthsFetchedControllerTest()
        let dataSource = SightDataSource(manager: CoreData.manager, fetchedController: fetchedController)
        controller.dataSource = dataSource
        _ = controller.view
        
        var indexPath = IndexPath(row: 1, section: 0) // def sight
//        let sight = controller.dataSource.item(at: indexPath)
        var actions = controller.tableView(controller.tableView, editActionsForRowAt: indexPath)

        XCTAssertNotNil(actions, "Row action should not be nil")
        XCTAssertNotNil(actions?.count == 1, "Default row action should be 1")
        
        //MARK: -

        indexPath = IndexPath(row: 0, section: 0) // user's sight
        actions = controller.tableView(controller.tableView, editActionsForRowAt: indexPath)
        
        XCTAssertNotNil(actions, "Row action should not be nil")
        XCTAssertNotNil(actions?.count == 2, "User's row action should be 2")
    }
}
