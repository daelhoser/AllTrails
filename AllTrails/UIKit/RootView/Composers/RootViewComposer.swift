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
    
    static func compose(with loader: PlaceLoader, and dataLoader: DataLoader) -> RootViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController() as! RootViewController
        rootViewController.loader = MainQueueDispatcherDecorator(decoratee: loader)
        rootViewController.listViewController = PlaceViewComposer.compose(with: MainQueueDispatcherDecorator(decoratee: dataLoader))
        rootViewController.onSearchButtonTapped = { [weak rootViewController] in
            guard let rootViewController = rootViewController else { return }
            
            presentSearchVC(loader, dataLoader: dataLoader, on: rootViewController)
        }
        
        return rootViewController
    }
    
    private static func presentSearchVC(_ placeLoader: PlaceLoader, dataLoader: DataLoader, on viewController: RootViewController) {
        let searchVC = SearchPlaceTableViewController(placeLoader: MainQueueDispatcherDecorator(decoratee: placeLoader), dataLoader: MainQueueDispatcherDecorator(decoratee: dataLoader))
        let navVC = UINavigationController(rootViewController: searchVC)
        viewController.present(navVC, animated: true, completion: nil)
    }
}
