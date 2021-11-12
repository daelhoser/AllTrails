//
//  PlaceViewModel.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

final class PlaceViewModel {
    private let model: Place
    
    var name: String {
        return model.name
    }
    
    var rating: Int {
        return Int(model.rating)
    }
    
    var numberOfRatings: String {
        return "(\(model.numberOfRatings))"
    }
    
    var priceAndSupportingText: String? {
        guard let priceLevel = model.priceLevel else {
            return model.vicinity
        }
        
        let temp = String(repeating: "$", count: priceLevel.rawValue)
        
        return "\(temp) • \(model.vicinity)"
    }
    
    init(model: Place) {
        self.model = model
    }
}
