//
//  SearchPlaceComposer.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/15/21.
//

import Foundation

final class SearchPlaceComposer {
    private init() {}
    
    static func compose(with placeLoader: PlaceLoader, dataLoader: DataLoader, centerCoordinate: LocationCoordinate) -> SearchPlaceTableViewController {
        return SearchPlaceTableViewController(placeLoader: MainQueueDispatcherDecorator(decoratee: placeLoader), dataLoader: MainQueueDispatcherDecorator(decoratee: dataLoader), centerCoordinate: centerCoordinate)
    }
}
