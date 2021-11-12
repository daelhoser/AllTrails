//
//  GeometryCodable.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

struct GeometryCodable: Decodable {
    let location: LocationCodable
    
    var toCoordinate: LocationCoordinate {
        LocationCoordinate(latitude: location.lat, longitude: location.lng)
    }
}

struct LocationCodable: Decodable {
    let lat: Double
    let lng: Double
}
