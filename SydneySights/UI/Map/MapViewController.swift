//
//  MapViewController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapMenuProtocol, ViewControllerStoryboard {
    
    static var storyboardName = "Main"
    
    @IBOutlet public private (set) weak var mapView: MKMapView!
    @IBOutlet private weak var currentLocationItem: MKUserTrackingBarButtonItem!
        
    @IBOutlet private weak var lockView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var sights: [SightProtocol]?
    var startCoordinateRegion: MKCoordinateRegion?
    var startSight: SightProtocol?
    
    private lazy var mapMenu: MenuProtocol = Menu(self, items: [])
    
    private lazy var searchManager: MapSearchManagerProtocol = SearchManager(mapView: self.mapView, controller: self)
    
    //MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        addSights(sights, with: startSight)
        if let startCoordinateRegion = startCoordinateRegion {
            mapView.setRegion(startCoordinateRegion, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cleanPoints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Map.engine.lastMapCoordinateRegion = mapView.region
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditViewController,
            let sight = sender as? Sight {
            controller.sight = sight
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func settingsButtonPressed(_ sender: UIBarButtonItem) {
        mapMenu.configureItem(at: Menu.ItemType.showTraffic.rawValue, imageAlpha: mapView.showsTraffic ? 1.0 : 0.3)
        PopupMenuViewController.showMenu(menuArray: mapMenu.items, from: sender, in: self)
    }
    
    private func saveNewPlace(_ place: MKPlacemark?) {
        guard let place = place else {
            return
        }
        
        let distance = Map.engine.distance(from: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        let newSight = Sight(place, distance: distance)
        newSight.save()
        sights?.append(newSight)
        
        let point = SightPointAnnotation(newSight)        
        
        mapView.addAnnotation(point)
        mapView.removeAnnotation(place)
    }
    
    //MARK: -
    
    private func configureMap() {
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsBuildings = true

        mapView.mapType = .standard
        mapView.delegate = self
        mapView.showsUserLocation = true
        currentLocationItem.mapView = mapView
        
        addLongTap()
    }
    
    private func addSights(_ sights: [SightProtocol]?, with startSight: SightProtocol?) {
        sights?.forEach {
            let point = SightPointAnnotation($0)
            mapView.addAnnotation(point)
            if startSight?.isEqual($0) ?? false {
                mapView.showAnnotations([point], animated: false)
                mapView.selectAnnotation(point, animated: false)
            }
        }
    }    
    
    private func addLongTap() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed))
        gestureRecognizer.minimumPressDuration = 0.7
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func longTapPressed(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        let touchPoint = recognizer.location(in: mapView)
        let mapCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let distance = Map.engine.distance(from: CLLocation(latitude: mapCoordinate.latitude, longitude: mapCoordinate.longitude))
        let newSight = Sight(coordinate: mapCoordinate, distance: distance)
        
        let point = SightPointAnnotation(newSight)
        
        mapView.addAnnotation(point)
        mapView.selectAnnotation(point, animated: true)
        
        newSight.save()
    }
    
    //MARK: -
    
    private func cleanPoints() {
        sights = sights?.filter { !$0.isFault }
        
        let pointsToDelete = mapView.annotations.compactMap { $0 as? SightPointAnnotation }.filter { $0.sight.isFault }
        mapView.removeAnnotations(pointsToDelete)
        
        mapView.selectedAnnotations.forEach {
            if let sightAnnotation = $0 as? SightPointAnnotation {
                sightAnnotation.updatePointAnnotation()
            }
        }
    }
    
    private func removeSearchedPlaces() {
        if let places = searchManager.searchedPlaces {
            mapView.removeAnnotations(places)
        }
    }
    
    //MARK: - Search
    
    func search() {
        showLockView(view: lockView)
        activityIndicator?.isHidden = true
        searchManager.search(startHandler: { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.removeSearchedPlaces()
        }, completionHandler: { [weak self] in
            self?.hideLockView(view: self?.lockView)
        })
    }
    
    private func showLockView(view: UIView?) {
        view?.alpha = 0.0
        view?.isHidden = false        
        UIView.animate(withDuration: 0.3) {
            view?.alpha = 0.6
        }
    }

    private func hideLockView(view: UIView?) {
        UIView.animate(withDuration: 0.1, animations: {
            view?.alpha = 0.0
        }, completion: { (isFinished) in
            if isFinished {
                self.activityIndicator?.isHidden = true
                view?.isHidden = true
            }
        })
    }
}

extension MapViewController: MKMapViewDelegate {
    
    private func placeView(_ place: MKPlacemark) -> PlacePinAnnotatonView {
        let button = InfoPlaceMapButton(place) { [weak self] (place) in
            self?.saveNewPlace(place)
        }
        let view = PlacePinAnnotatonView(place, button: button)
        return view
    }
    
    private func sightView(_ annotation: SightPointAnnotation, sight: SightProtocol) -> SightPinAnnotatonView {
        let button = InfoSightMapButton(sight) { [weak self] (sight) in
            self?.performSegue(withIdentifier: String(describing: EditViewController.self), sender: sight)
        }
        
        let view = SightPinAnnotatonView(annotation, button: button)
        return view
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let place = annotation as? MKPlacemark {
            return placeView(place)
        }

        if let annotation = annotation as? SightPointAnnotation,
            let sight = annotation.sight {
            return sightView(annotation, sight: sight)
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .ending:
            view.dragState = .none
            if let sightAnnotation = view.annotation as? SightPointAnnotation {
                sightAnnotation.updateSightCoordinate()
                sightAnnotation.sight.save()
            }
        case .canceling:
            view.dragState = .none
        default: return
        }
    }

}
