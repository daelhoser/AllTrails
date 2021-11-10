//
//  Place.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/10/21.
//

import Foundation

struct Place {
    let id: String
    let name: String
    let rating: Double
    let numberOfRatings: Int
    let iconURL: URL
    let priceLevel: PriceLevel
    let coordinates: LocationCoordinate
}
