//
//  PlaceViewModel.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

final class PlaceViewModel<Image> {
    let model: Place
    private let imageLoader: DataLoader
    private var imageLoaderTask: RequestTask?
    private let imageTransformer: (Data) -> Image?
    private let favoritesLoader: FavoritePlaceLoader
    private let favoriteCache: FavoritePlaceCache
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
    
    var isFavorited: Bool {
        favoritesLoader.isFavorited(placeId: model.id)
    }
    
    var onImageCompletion: ((Image?) -> Void)?
    
    init(model: Place, imageLoader: DataLoader, favoritesLoader: FavoritePlaceLoader, favoritesCache: FavoritePlaceCache, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.favoritesLoader = favoritesLoader
        self.favoriteCache = favoritesCache
        self.imageTransformer = imageTransformer
    }
    
    func loadImage() {
        guard imageLoaderTask == nil else { return }
        
        imageLoaderTask = imageLoader.request(from: model.iconURL, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            if let data = try? result.get() {
                let image = self.imageTransformer(data)
                self.onImageCompletion?(image)
            } else {
                self.onImageCompletion?(nil)
            }
        })
    }
    
    func cancelImageLoad() {
        imageLoaderTask?.cancel()
        imageLoaderTask = nil
    }
    
    func favorite() {
        favoriteCache.save(placeId: model.id)
    }
    
    func unfavorite() {
        favoriteCache.delete(placeId: model.id)
    }
}
