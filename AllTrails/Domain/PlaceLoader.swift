//
//  PlaceLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/10/21.
//

import Foundation

protocol PlaceLoader {
    typealias Result = Swift.Result<[Place], Error>
    
    func load(with request: Request, completion: @escaping (Result) -> Void) -> RequestTask
}


protocol FavoritePlaceCache {
    func save(placeId: String)
    func delete(placeId: String)
}

protocol FavoritePlaceLoader {
    func isFavorited(placeId: String) -> Bool
}
