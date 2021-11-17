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
    private var controllers = [MapAnnotationViewController]()
    
    var loader: PlaceLoader!
    
    var onUpdate: (([Place]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
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
        searchAroundCurrentLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let annotationIdentifier = "cell"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }

        annotationView!.image = UIImage(named: "static")

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "active")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "clicked")
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
                self?.onUpdate?(places)
            case .failure:
                self?.onUpdate?([Place]())
            }
        })
    }
    
    private func renderPlaces(_ places: [Place]) {
        self.controllers.removeAll()
        let controllers = places.map { MapAnnotationViewController(place: $0) }
        self.controllers.append(contentsOf: controllers)
        mapView.addAnnotations(controllers.map { $0.annotation })
    }
    
    private func latitudeDeltaToMeters(_ latitudeDelta: CLLocationDegrees) -> Int {
        // 1 degree latitude = 169 miles = 271979 meters
        
        let temp = Double(latitudeDelta) * Self.metersInOneDegreeLatitudeDelta
        
        return Int(temp)
    }
}


