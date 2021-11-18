//
//  PlaceView.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlaceView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var numberOfRatings: UILabel!
    @IBOutlet weak var priceAndDetail: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    var onHeartButtonTapped: ((_ liked: Bool) -> Void)?
    
    @IBAction func heartButtonTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        onHeartButtonTapped?(button.isSelected)
    }
}
