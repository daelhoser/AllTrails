//
//  PlaceViewModel.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation
import UIKit

final class PlaceViewModel {
    private let model: Place
    private let imageLoader: DataLoader
    private var task: RequestTask?
    
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
    
    var onImageCompletion: ((UIImage?) -> Void)?
    
    init(model: Place, imageLoader: DataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImage() {
        guard task == nil else { return }
        
        task = imageLoader.request(from: model.iconURL, completion: { [weak self] (result) in
            if let data = try? result.get() {
                let image = UIImage(data: data)
                self?.onImageCompletion?(image)
            } else {
                self?.onImageCompletion?(nil)
            }
        })
    }
    
    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
}
