//
//  MapViewComposer.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/16/21.
//

import Foundation
import UIKit

final class MapViewComposer {
    private init() {}
    
    static func compose(loader: PlaceLoader, imageLoader: DataLoader, favoritesLoader: FavoritePlaceLoader, favoritesCache: FavoritePlaceCache) -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController") as MapViewController
        mapViewController.loader = MainQueueDispatcherDecorator(decoratee: loader)
        mapViewController.imageLoader = MainQueueDispatcherDecorator(decoratee: imageLoader)
        mapViewController.favoritesLoader = favoritesLoader
        mapViewController.favoriteCache = favoritesCache
        
        return mapViewController
    }
}
