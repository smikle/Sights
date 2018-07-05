//
//  InitialDataManger.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

class InitialDataManger {
    
    static let defJSONFileName = "locations.json"
    
    private weak var parentController: UIViewController?    
    private var cdManager: CoreDataJSONProtocol!
    
    init(controller: UIViewController, coreDataManager: CoreDataJSONProtocol) {
        self.parentController = controller
        self.cdManager = coreDataManager
    }
    
    //MARK: - Public
    
    func populateSights() {
        locationsFromNet { (data) in
            guard let data = data else {
                self.handleErrorFromNet()
                return
            }
            
            self.importLocations(data)
        }
    }
    
    //MARK: - Private
    
    private func importLocations(_ data: Data) {
        if !cdManager.jsonImport(data) {
            return
        }
        
        cdManager.saveContext()
    }
    
    private func handleErrorFromNet() {
        let alert = AlertViewController(title: "Some network error", message: "Load default data?", buttonTitles: ["Yes", "No"]) { (index) in
            if index == 0,
                let data = self.defLocationsDataFromBundle() {
                self.importLocations(data)
            }
        }
        
        parentController?.present(alert, animated: true, completion: nil)
    }
    
    private func defLocationsDataFromBundle() -> Data? {
        guard let filePath = Bundle.main.path(forResource: InitialDataManger.defJSONFileName, ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                return nil
        }
        
        return data
    }
    
    private func locationsFromNet(comppletion: @escaping (Data?) -> Void ) {
        let locations = Locations()
        locations.from { (model) in
            guard let array = model?.locations,
                let data = try? JSONEncoder().encode(array) else {
                    comppletion(nil)
                    return
            }
            
            comppletion(data)
        }
    }
    
}
