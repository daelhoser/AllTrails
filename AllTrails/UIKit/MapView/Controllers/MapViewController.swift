//
//  MapViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/15/21.
//

import UIKit
import MapKit

final class MapViewComposer {
    private init() {}
    
    static func compose(loader: PlaceLoader) -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController") as MapViewController
        mapViewController.loader = MainQueueDispatcherDecorator(decoratee: loader)
        
        return mapViewController
    }
}

final class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet private weak var mapView: MKMapView!

    private static let metersInOneDegreeLatitudeDelta: Double = 271979
    
    private let locationManager = CLLocationManager()
    private var task: RequestTask?
    
    var loader: PlaceLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            navigateToUsersLocation()
        case .authorizedWhenInUse:
            navigateToUsersLocation()
        case .denied:
            searchAroundCurrentLocation()
        case .restricted:
            searchAroundCurrentLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        searchAroundCurrentLocation()
    }
            
    // MARK: - Helper Methods
    
    private func navigateToUsersLocation () {
        if let location = locationManager.location?.coordinate {
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
            case .failure:
                break
            }
        })
    }
    
    private func renderPlaces(_ places: [Place]) {
        let annotations = places.map { (place) -> MKPointAnnotation in
            let c = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = c
            annotation.title = place.name
            
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func latitudeDeltaToMeters(_ latitudeDelta: CLLocationDegrees) -> Int {
        // 1 degree latitude = 169 miles = 271979 meters
        
        let temp = Double(latitudeDelta) * Self.metersInOneDegreeLatitudeDelta
        
        return Int(temp)
    }
}
