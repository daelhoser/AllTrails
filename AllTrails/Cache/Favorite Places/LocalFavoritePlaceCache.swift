//
//  LocalFavoritePlaceCache.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/17/21.
//

import Foundation

final class LocalFavoritePlaceCache: FavoritePlaceCache, FavoritePlaceLoader {
    //NOTE: I didn't create a 'Store' protocol that would allow me to save to different stores but i think i'm past my 5hr limit. I'm also not including thread checks which is a bad idea.
    struct LocalFavorites: Codable {
        let places: [LocalFavorite]
    }
    struct LocalFavorite: Codable {
        let placeId: String
    }
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var favorites = [LocalFavorite]()
    
    func save(placeId: String) {
        let contains = favorites.contains { $0.placeId == placeId }
        
        if !contains {
            favorites.append(LocalFavorite(placeId: placeId))
        }
    }
    
    func delete(placeId: String) {
        let index = favorites.firstIndex { $0.placeId == placeId }
        
        if let index = index {
            favorites.remove(at: index)
        }
    }
    
    // MARK: - FavoritePlaceLoader
    
    func isFavorited(placeId: String) -> Bool {
        return favorites.contains { $0.placeId == placeId }
    }

    
    // MARK: - Helper Methods

    func load() {
        let data = Data()
        
        do {
            let favoriteList = try decoder.decode(LocalFavorites.self, from: data)
            favorites.append(contentsOf: favoriteList.places)
        } catch  {
        }
    }

    func save() {
        let favorites = LocalFavorites(places: favorites)
        
        do {
            let data = try encoder.encode(favorites)
            
        } catch {
            
        }
    }
}
