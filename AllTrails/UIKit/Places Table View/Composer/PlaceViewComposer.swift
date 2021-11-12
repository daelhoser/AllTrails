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
    
    static func compose(with dataLoader: DataLoader) -> PlacesTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PlacesTableViewController") as! PlacesTableViewController
        viewController.dataLoader = MainQueueDispatcherDecorator(decoratee: dataLoader)
        
        return viewController
    }
}
