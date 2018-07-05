//
//  ViewController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit
import MapKit

protocol UpdateLocationProtocol: class {
    func locationDidUpdate(_ location: CLLocation?)
}

class SightListViewController: UIViewController, ViewControllerStoryboard {
    
    static var storyboardName = "Main"
    
    @IBOutlet private (set) weak var tableView: UITableView!
    
    lazy var dataSource: SigthsDataSourceProtocol = SightDataSource(manager: CoreData.manager)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        dataSource.fetch()
        checkSights()
        
        Map.engine.locationUpdateDelegate = self
        Map.engine.locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDistance(Map.engine.lastCurrentLocation)
    }

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditViewController,
            let sight = sender as? SightProtocol {
            controller.sight = sight
            return
        }

        if let controller = segue.destination as? MapViewController {
            controller.sights = dataSource.items
            if let sight = (sender as? SightCell)?.item {
                controller.startSight = sight
            } else {
                controller.startCoordinateRegion = Map.engine.lastMapCoordinateRegion
            }
            return
        }
    }
    
    //MARK: -

    private func configure() {
        dataSource.tableView = tableView
        tableView?.dataSource = dataSource
        tableView?.delegate = self
    }
    
    private func delete(at indexPath: IndexPath) {
        dataSource.delete(at: indexPath)
    }
    
    private func edit(at indexPath: IndexPath) {
        let obj = dataSource.item(at: indexPath)
        performSegue(withIdentifier: String(describing: EditViewController.self), sender: obj)
    }

}

extension SightListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let obj = dataSource.item(at: indexPath)
        
        let editAction =  UITableViewRowAction(style: .normal, title: "Edit", handler: { [weak self] _, indexPath in
            self?.edit(at: indexPath)
        })

        if !obj.isUserPoint {
            return [editAction]
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { [weak self] _, indexPath in
            self?.delete(at: indexPath)
        })
        
        return [editAction, deleteAction]
    }
}

extension SightListViewController: UpdateLocationProtocol {
    func locationDidUpdate(_ location: CLLocation?) {
        guard let location = location,
            (view.window?.rootViewController as? UINavigationController)?.topViewController == self else {
            return
        }
        
        updateDistance(location)
    }
    
    func updateDistance(_ location: CLLocation?) {
        guard let location = location else {
            return
        }
        
        dataSource.items.forEach {
            $0.distance = Int32(location.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude)))
        }
    }
}

extension SightListViewController {
    private func checkSights() {
        guard dataSource.isEmpty else {
            return
        }
        
        InitialDataManger(controller: self, coreDataManager: CoreData.manager).populateSights()
    }    
}
