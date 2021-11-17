//
//  MapViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/15/21.
//

import UIKit
import MapKit

protocol PlacesMapViewDelegate: AnyObject {
    func userMovedMapView()
}

final class PlacesMapView: MKMapView {
    weak var userMovementDelegate: PlacesMapViewDelegate?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        userMovementDelegate?.userMovedMapView()
    }
}

final class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, PlacesMapViewDelegate {
    @IBOutlet private weak var mapView: PlacesMapView!

    private static let metersInOneDegreeLatitudeDelta: Double = 271979
    
    private let locationManager = CLLocationManager()
    private var task: RequestTask?
    private var controllers = [MapAnnotationController]()
    private var allowSearchOnRegionChange = false

    var loader: PlaceLoader!
    var imageLoader: DataLoader!
    var centerPoint: LocationCoordinate {
        return LocationCoordinate(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    var onUpdate: (([Place]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userMovementDelegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func renderPlaces(_ places: [Place]) {
        self.controllers.removeAll()
        removeOldAnnotations()
        let controllers = places.map { MapAnnotationController(viewModel: PlaceViewModel(model: $0, imageLoader: imageLoader, imageTransformer: UIImage.init)) }
        self.controllers.append(contentsOf: controllers)
        mapView.addAnnotations(controllers.map { $0.annotation })
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingHeading()
            navigateToUsersLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingHeading()
            navigateToUsersLocation()
        case .denied:
            locationManager.stopUpdatingLocation()
            searchAroundCurrentLocation()
        case .restricted:
            locationManager.stopUpdatingLocation()
            searchAroundCurrentLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if allowSearchOnRegionChange {
            allowSearchOnRegionChange = false
            searchAroundCurrentLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let controller = controller(for: annotation)

        return controller?.mapView(mapView, viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let controller = controller(for: view.annotation)

        controller?.mapView(mapView, didSelect: view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let controller = controller(for: view.annotation)

        controller?.mapView(mapView, didDeselect: view)
    }
    
    // MARK: - PlacesMapViewDelegate
        
    func userMovedMapView() {
        allowSearchOnRegionChange = true
    }

            
    // MARK: - Helper Methods
    
    private func removeOldAnnotations() {
        let currentAnnotations = mapView.annotations
        mapView.removeAnnotations(currentAnnotations)
    }
    
    private func controller(for annotation: MKAnnotation?) -> MapAnnotationController? {
        guard let annotation = annotation as? PlaceAnnotation else {
            return nil
        }
        
        return controllers.first { $0.annotation.placeId == annotation.placeId }
    }
    
    private func navigateToUsersLocation () {
        if let location = locationManager.location?.coordinate {
            allowSearchOnRegionChange = true
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) // 1 delta = 69 miles, 0.1 delta = 6.9 miles
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func searchAroundCurrentLocation() {
        task?.cancel()
        task = nil
        
        // TODO: Perhaps we should get keyword if user searched for something there
        let currentCenter = mapView.centerCoordinate
        let locationCoordinate = LocationCoordinate(latitude: currentCenter.latitude, longitude: currentCenter.longitude)
        let latitudeDelta = mapView.region.span.latitudeDelta
        let request = Request(keyword: nil, coordinates: locationCoordinate, radius: latitudeDeltaToMeters(latitudeDelta))

        
        task = loader.load(with: request, completion: { [weak self] (result) in
            switch result {
            case let .success(places):
                self?.renderPlaces(places)
                self?.onUpdate?(places)
            case .failure:
                self?.onUpdate?([Place]())
            }
        })
    }
        
    private func latitudeDeltaToMeters(_ latitudeDelta: CLLocationDegrees) -> Int {
        // 1 degree latitude = 169 miles = 271979 meters
        
        let temp = Double(latitudeDelta) * Self.metersInOneDegreeLatitudeDelta
        
        return Int(temp)
    }
}

