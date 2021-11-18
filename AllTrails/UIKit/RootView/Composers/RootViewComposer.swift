//
//  RootViewComposer.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/13/21.
//

import Foundation
import UIKit

final class RootViewComposer {
    private init() {}
    
    static func compose(with loader: PlaceLoader, and dataLoader: DataLoader, favoritesLoader: FavoritePlaceLoader, favoritesCache: FavoritePlaceCache) -> RootViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController() as! RootViewController
        rootViewController.listViewController = PlaceViewComposer.compose(with: MainQueueDispatcherDecorator(decoratee: dataLoader), favoritesLoader: favoritesLoader, favoritesCache: favoritesCache)
        rootViewController.mapViewController = MapViewComposer.compose(loader: loader, imageLoader: dataLoader, favoritesLoader: favoritesLoader, favoritesCache: favoritesCache)
        rootViewController.onSearchButtonTapped = { [weak rootViewController] in
            guard let rootViewController = rootViewController else { return }
            
            presentSearchVC(loader, dataLoader: dataLoader, favoritesLoader: favoritesLoader, favoritesCache: favoritesCache, on: rootViewController)
        }
        
        return rootViewController
    }
    
    private static func presentSearchVC(_ placeLoader: PlaceLoader, dataLoader: DataLoader, favoritesLoader: FavoritePlaceLoader, favoritesCache: FavoritePlaceCache, on viewController: RootViewController) {
        let searchVC = SearchPlaceComposer.compose(with: placeLoader, dataLoader: dataLoader, favoritesLoader: favoritesLoader, favoritesCache: favoritesCache, centerCoordinate: viewController.mapViewController.centerPoint)
        searchVC.delegate = viewController
        let navVC = UINavigationController(rootViewController: searchVC)
        viewController.present(navVC, animated: true, completion: nil)
    }
}
