//
//  Sight+MapKit.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import MapKit

extension Sight {
    
    convenience init(_ place: MKPlacemark, distance: Int32, isUserPoint: Bool = true) {
        self.init(isUserPoint: isUserPoint)
 
        self.name = place.title ?? ""
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        self.distance = distance
    }
 
    convenience init(coordinate: CLLocationCoordinate2D, distance: Int32, isUserPoint: Bool = true) {
        self.init(isUserPoint: isUserPoint)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.distance = distance
    }
    
}
