//
//  MapAnnotationController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/16/21.
//

import Foundation
import MapKit

final class MapAnnotationController: NSObject, MKMapViewDelegate {
    private let place: Place
    private var isSelected = false
    
    lazy var annotation: PlaceAnnotation = {
        let coordinate = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
        let annotation = PlaceAnnotation(placeId: place.id)
        annotation.coordinate = coordinate
        annotation.title = place.name
        
        return annotation
    }()
    
    init(place: Place) {
        self.place = place
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

        annotationView!.image = isSelected ? UIImage(named: "clicked") : UIImage(named: "static")

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        isSelected = true
        view.image = UIImage(named: "active")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "clicked")
    }
}
