//
//  MapAnnotationController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/16/21.
//

import Foundation
import MapKit

final class MapAnnotationController: NSObject, MKMapViewDelegate {
    private let viewModel: PlaceViewModel<UIImage>
    private var isSelected = false
    
    lazy var annotation: PlaceAnnotation = {
        let place = viewModel.model
        let coordinate = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
        let annotation = PlaceAnnotation(placeId: place.id)
        annotation.coordinate = coordinate
        
        return annotation
    }()
    
    init(viewModel: PlaceViewModel<UIImage>) {
        self.viewModel = viewModel
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
        
        annotationView?.detailCalloutAccessoryView = createPlaceView()

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        isSelected = true
        view.image = UIImage(named: "active")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "clicked")
        viewModel.cancelImageLoad()
    }
    
    // MARK: - Helper Methods
    
    private func createPlaceView() -> PlaceView {
        let nib = UINib(nibName: "PlaceView", bundle: nil)
        let placeView = nib.instantiate(withOwner: nil, options: nil).first as! PlaceView
        placeView.removePadding()
        placeView.name.text = viewModel.name
        placeView.numberOfRatings.text = viewModel.numberOfRatings
        placeView.priceAndDetail.text = viewModel.priceAndSupportingText
        placeView.ratingImageView.image = imageFor(rating: viewModel.rating)
        placeView.heartButton.isHidden = true
        
        viewModel.onImageCompletion = { [weak placeView] (image) in
            placeView?.iconImageView.image = image
        }
        viewModel.loadImage()
        
        return placeView
    }

    private func imageFor(rating: Int) -> UIImage? {
        let imageName: String
        
        switch viewModel.rating {
        case 0:
            imageName = "1Stars"
        case 2:
            imageName = "2Stars"
        case 3:
            imageName = "3Stars"
        case 4:
            imageName = "4Stars"
        case 5:
            imageName = "5Stars"
        default:
            imageName = "1Stars"
        }
        

        return UIImage(named: imageName)
    }
}
