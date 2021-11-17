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
    
    static func compose(loader: PlaceLoader) -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mapViewController = storyboard.instantiateViewController(identifier: "MapViewController") as MapViewController
        mapViewController.loader = MainQueueDispatcherDecorator(decoratee: loader)
        
        return mapViewController
    }
}
