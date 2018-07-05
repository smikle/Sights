//
//  EditViewControllerTest.swift
//  SydneySightsTests
//
//  Created by Mikhail Stetcura on 7/4/18.
//  Copyright © 2018 SML. All rights reserved.
//

import XCTest
@testable import SydneySights

class SightTest: NSObject, SightProtocol {
    var name: String!
    var descr: String?
    var longitude: Double
    var latitude: Double
    
    var isUserPoint: Bool
    
    var distance: Int32 = 0    
    var isFault: Bool = false
    
    init(name: String, descr: String, longitude: Double, latitude: Double, isUserPoint: Bool, distance: Int32 = 0) {
        self.isUserPoint = true
        
        self.name = name
        self.descr = descr
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var isSaved: Bool =  false
    var isRollbacked: Bool = false
    
    @discardableResult
    func save() -> Bool {
        isSaved = true
        return true
    }
    
    func rollback() {
        isRollbacked = true
    }
}

class EditViewControllerTest: XCTestCase {

    var controller: EditViewController!
    let testSight = SightTest(name: "TEST NAME FOR SIGHT", descr: "TEST DESCRIPTION FOR SIGHT", longitude: 789.012, latitude: 123.456, isUserPoint: true)
    
    override func setUp() {
        super.setUp()
        controller = EditViewController.controller() as? EditViewController
        controller.sight = testSight
        _ = controller.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: -

    func testSaveButton() {
        let controller: EditViewController! = EditViewController.controller() as? EditViewController
        let saveButton = controller.navigationItem.rightBarButtonItem
        
        XCTAssertNotNil(saveButton, "Save button should not be nil!")
        XCTAssertEqual(saveButton!.action, #selector(EditViewController.saveButtonPressed(_:)), "Action should be 'saveButtonPressed' !")
    }

    func testActionSaveButton() {
        let saveButton = controller.navigationItem.rightBarButtonItem
        
        controller.nameTextField.text = "NEW NAME FOR TEST"
        controller.descrTextField.text = "NEW DESCRIPTION FOR TEST"
        controller.longitudeTextField.text = "45.678"
        controller.latitudeTextField.text = "12.345"
        
        _ = saveButton!.target!.perform(saveButton!.action, with: nil)

        XCTAssertTrue(testSight.isSaved, "Sight should be saved")
        
        XCTAssertEqual(controller.nameTextField.text, testSight.name)
        XCTAssertEqual(controller.descrTextField.text, testSight.descr)
        XCTAssertEqual(controller.longitudeTextField.text, "\(testSight.longitude)")
        XCTAssertEqual(controller.latitudeTextField.text, "\(testSight.latitude)")
    }
    
    func testUIComponents() {        
        textFieldCheck(textField: controller.nameTextField, nameTextField: "name", sightValue: testSight.name)
        textFieldCheck(textField: controller.descrTextField, nameTextField: "description", sightValue: testSight.descr!)
        textFieldCheck(textField: controller.longitudeTextField, nameTextField: "longitude", sightValue: "\(testSight.longitude)")
        textFieldCheck(textField: controller.latitudeTextField, nameTextField: "latitude", sightValue: "\(testSight.latitude)")
    }
    
    func textFieldCheck(textField: UITextField?, nameTextField: String, sightValue: String) {
        XCTAssertNotNil(textField, "\(nameTextField) TextField should not be nil!")
        XCTAssertEqual(textField!.text, sightValue, "\(nameTextField) [\(textField!.text ?? "nil")] should be equal to \(sightValue ) !")
    }
    
    //MARK: -
    
    func testCoordinateEditable() {
        var isEditable = controller.longitudeTextField.delegate?.textFieldShouldBeginEditing?(controller.longitudeTextField)
        XCTAssertTrue(isEditable!, "Coordinate longitude for user's points should be editable")
        isEditable = controller.latitudeTextField.delegate?.textFieldShouldBeginEditing?(controller.latitudeTextField)
        XCTAssertTrue(isEditable!, "Coordinate latitude for user's points should be editable")

        controller.sight?.isUserPoint = false
        
        isEditable = controller.longitudeTextField.delegate?.textFieldShouldBeginEditing?(controller.longitudeTextField)
        XCTAssertFalse(isEditable!, "Coordinate longitude for default points should be non editable")
        isEditable = controller.latitudeTextField.delegate?.textFieldShouldBeginEditing?(controller.latitudeTextField)
        XCTAssertFalse(isEditable!, "Coordinate latitude for default points should be non editable")
    }
    
    //MARK: -
    
    func testRollback() {
        XCTAssertFalse(testSight.isRollbacked, "Sight should be non rollbacked!")
        controller.viewWillDisappear(false)
        XCTAssertTrue(testSight.isRollbacked, "Sight should be rollbacked!")
    }
}
