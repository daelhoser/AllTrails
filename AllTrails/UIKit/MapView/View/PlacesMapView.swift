//
//  PlacesMapView.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/17/21.
//

import Foundation
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
