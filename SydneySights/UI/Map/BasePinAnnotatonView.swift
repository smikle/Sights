//
//  BasePinAnnotatonView.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/2/18.
//  Copyright © 2018 SML. All rights reserved.
//

import MapKit

class BasePinAnnotatonView<T>: MKPinAnnotationView where T: MKAnnotation {
    
    convenience init(_ annotation: T, button: UIButton?) {
        self.init(annotation: annotation, reuseIdentifier: "MyPin")
        self.rightCalloutAccessoryView = button
        
        configure(annotation)
    }
    
    func configure(_ annotation: T) {
        pinTintColor = .red
        isDraggable = true
        canShowCallout = true
    }
}

//MARK: - 

class SightPinAnnotatonView: BasePinAnnotatonView<SightPointAnnotation> {
    override func configure(_ annotation: SightPointAnnotation) {
        super.configure(annotation)
        pinTintColor = (annotation.sight?.isUserPoint ?? true) ? .red : UIColor.darkGray
        isDraggable =  annotation.sight?.isUserPoint ?? false
    }
}

//MARK: -

class PlacePinAnnotatonView: BasePinAnnotatonView<MKPlacemark> {
    override func configure(_ annotation: MKPlacemark) {
        super.configure(annotation)
        pinTintColor = .blue
        isDraggable = false
    }
}
