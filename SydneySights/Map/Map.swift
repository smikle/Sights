//
//  MapEngine.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import MapKit

class Map: NSObject {
    
    static let engine = Map()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        return manager
    }()
    
    weak var locationUpdateDelegate: UpdateLocationProtocol?
    var lastMapCoordinateRegion: MKCoordinateRegion?
    
    var lastCurrentLocation: CLLocation? {
        didSet {
            guard let newLocation = lastCurrentLocation else {
                return
            }
            
            if oldValue?.distance(from: newLocation) ?? 0 > 100 || oldValue == nil {
                locationUpdateDelegate?.locationDidUpdate(lastCurrentLocation)
            }
        }
    }
    
    func distance(from location: CLLocation) -> Int32 {
        return Int32(lastCurrentLocation?.distance(from: location) ?? 0)
    }
    
    func distance(latitude: Double, longitude: Double) -> Int32 {
        return distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    //MARK: -
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension Map: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dPrint(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastCurrentLocation = locations.first
    }
    
}
