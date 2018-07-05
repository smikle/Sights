//
//  MapMenuProtocol.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/4/18.
//  Copyright © 2018 SML. All rights reserved.
//

import MapKit

protocol MapMenuProtocol: class {
    
    var mapView: MKMapView! { get }
    
    func nextMapType()
    func changeShowingTraffic()
    func search()
    func open(in: String)
}

extension MapMenuProtocol {
    
    func nextMapType() {
        if mapView.mapType == .hybridFlyover {
            mapView.mapType = .standard
            return
        }
        if let newType = MKMapType(rawValue: mapView.mapType.rawValue + 1) {
            mapView.mapType = newType
        }
    }
    
    func changeShowingTraffic() {
        mapView.showsTraffic = !mapView.showsTraffic
    }
    
    func open(in serviceName: String) {
        guard let url = urlForOpen(in: serviceName) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    private func urlForOpen(in serviceName: String) -> URL? {
        let currentSpan = mapView.region.span
        let urlString = "http://\(serviceName)/?ll=\(mapView.centerCoordinate.latitude),\(mapView.centerCoordinate.longitude)&spn=\(currentSpan.latitudeDelta),\(currentSpan.longitudeDelta)"
        
        return URL(string: urlString)
    }
}
