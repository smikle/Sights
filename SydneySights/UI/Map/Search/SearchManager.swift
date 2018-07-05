//
//  SearchManager.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/2/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit
import MapKit

protocol MapSearchManagerProtocol: class {
    typealias SearchCompletionHandler = () -> Void
    typealias SearchStartHandler = () -> Void
    
    var searchedPlaces: [MKPlacemark]? { get }

    func search(startHandler: SearchStartHandler?, completionHandler: SearchCompletionHandler?)
}

class SearchManager: MapSearchManagerProtocol {
    
    private weak var mapView: MKMapView?
    private weak var parentController: UIViewController?
    
    private var alertController: AlertViewController?
    private (set) var searchedPlaces: [MKPlacemark]?
    
    private var completionHandler: SearchCompletionHandler?
    
    //MARK: -
    
    init(mapView: MKMapView, controller: UIViewController) {
        self.mapView = mapView
        self.parentController = controller
    }
    
    //MARK: -
    
    func search(startHandler: SearchStartHandler?, completionHandler: SearchCompletionHandler?) {
        self.completionHandler = completionHandler
        
        if alertController == nil {
            alertController = AlertViewController(title: "Search", completionHandler: { [weak self] (alertButton, string) in
                if alertButton == .ok {
                    startHandler?()
                    self?.search(text: string)
                    return
                }
                
                self?.completionHandler?()
                
            }, textFieldConfigurationHandler: { (textField) in
                textField?.text = ""
                textField?.clearButtonMode = .always
            })
        }
        
        guard let controller = alertController else {
            return
        }
        
        parentController?.present(controller, animated: true, completion: nil)
    }
    
    //MARK: -
    
    private func search(text: String?) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        if let region = mapView?.region {
            request.region = region
        }
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            if error != nil {
                dPrint(error as Any)
                let alert = AlertViewController(title: "Error", message: error?.localizedDescription, buttonTitles: ["Ok"], completionHandler: { (_) in
                    self?.completionHandler?()
                })
                self?.parentController?.present(alert, animated: true, completion: nil)
            }
            
            let places = response?.mapItems.compactMap { $0.placemark }
            
            if let searchedPlaces = self?.searchedPlaces {
                self?.mapView?.removeAnnotations(searchedPlaces)
            }
            
            self?.searchedPlaces = places
            if let searchPlaces = self?.searchedPlaces {
                self?.mapView?.showAnnotations(searchPlaces, animated: true)
            }
            self?.completionHandler?()
        }
    }
}
