//
//  PlaceCellController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation
import UIKit

final class PlaceCellController: NSObject, UITableViewDataSource {
    private let viewModel: PlaceViewModel<UIImage>
    private var cell: PlaceTableViewCell?
    
    var model: Place {
        viewModel.model
    }
    
    init(viewModel: PlaceViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as? PlaceTableViewCell
        
        cell?.name = viewModel.name
        cell?.numberOfRatings = viewModel.numberOfRatings
        cell?.priceAndDetail = viewModel.priceAndSupportingText
        updateCellStarRating()
        
        viewModel.onImageCompletion = { [weak self] image in
            self?.cell?.setPlaceImage(image)
        }
        
        viewModel.loadImage()
        
        return cell!
    }
    
    func loadImage() {
        viewModel.loadImage()
    }
    
    func cancelImageLoad() {
        viewModel.cancelImageLoad()
    }
    
    private func updateCellStarRating() {
        let imageName: String
        
        switch viewModel.rating {
        case 0:
            imageName = "1Stars"
        case 2:
            imageName = "2Stars"
        case 3:
            imageName = "3Stars"
        case 4:
            imageName = "4Stars"
        case 5:
            imageName = "5Stars"
        default:
            imageName = "1Stars"
        }
        
        cell?.setStarRating(with: UIImage(named: imageName))
    }
}
