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
        rootViewController.listViewController = PlaceViewComposer.compose(with: dataLoader)
        
        return rootViewController
    }
}
