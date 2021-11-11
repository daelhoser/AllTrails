//
//  GeometryCodable.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

struct GeometryCodable: Decodable {
    let lat: Double
    let lng: Double
    
    var toCoordinate: LocationCoordinate {
        LocationCoordinate(latitude: lat, longitude: lng)
    }
}
