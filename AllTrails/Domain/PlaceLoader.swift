//
//  PlaceLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/10/21.
//

import Foundation

struct Request {
    let keyword: String?
    let coordinates: LocationCoordinate
    let radius: Int
    let type: String
}

struct LocationCoordinate {
    let latitude: Double
    let longitude: Double
}

enum PriceLevel {
    case free
    case inexpensive
    case moderate
    case expensive
    case veryExpensive
}

struct Place {
    let name: String
    let rating: Double
    let numberOfRatings: Int
    let iconURL: URL
    let priceLevel: PriceLevel
    let coordinates: LocationCoordinate
}

protocol PlaceLoader {
    func load(with request: Request, completion: @escaping (Result<[Place], Error>) -> Void)
}
