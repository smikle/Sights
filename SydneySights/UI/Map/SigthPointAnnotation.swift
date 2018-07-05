//
//  SigthPointAnnotation.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import MapKit

class SightPointAnnotation: MKPointAnnotation {
    
    public private (set) var sight: SightProtocol!

    init(_ sight: SightProtocol) {
        super.init()

        self.sight = sight
        self.coordinate = CLLocationCoordinate2D(latitude: sight.latitude, longitude: sight.longitude)
        self.title = sight.name
        self.subtitle = sight.descr
    }
    
    func updateSightCoordinate() {
        sight.latitude = coordinate.latitude
        sight.longitude = coordinate.longitude
        sight.distance = Map.engine.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
    
    func updatePointAnnotation() {
        coordinate = CLLocationCoordinate2D(latitude: sight.latitude, longitude: sight.longitude)
        title = sight.name
        subtitle = sight.descr
    }

}
