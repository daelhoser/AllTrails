//
//  PlaceViewComposer.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation
import UIKit
final class PlaceViewComposer {
    private init() {}
    
    static func compose(with dataLoader: DataLoader, favoritesLoader: FavoritePlaceLoader, favoritesCache: FavoritePlaceCache) -> PlacesTableViewController {
        return PlacesTableViewController(dataLoader: MainQueueDispatcherDecorator(decoratee: dataLoader), favoritesLoader: favoritesLoader, favoritesCache: favoritesCache)
    }
}
