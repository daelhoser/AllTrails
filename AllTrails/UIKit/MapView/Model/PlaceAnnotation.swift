//
//  PlaceAnnotation.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/16/21.
//

import Foundation
import MapKit

final class PlaceAnnotation: MKPointAnnotation {
    let placeId: String
    
    init(placeId: String) {
        self.placeId = placeId
    }
}
