//
//  PlaceCodable.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

struct PlaceCodable: Decodable {
    let place_id: String
    let name: String
    let rating: Double
    let user_ratings_total: Int
    let icon: String
    let price_level: Int
    let geometry: GeometryCodable
    
    var toPlace: Place {
        return Place(id: place_id, name: name, rating: rating, numberOfRatings: user_ratings_total, iconURL: URL(string: icon)!, priceLevel: PriceLevel(rawValue: price_level) ?? .free, coordinates: geometry.toCoordinate)
    }
}
