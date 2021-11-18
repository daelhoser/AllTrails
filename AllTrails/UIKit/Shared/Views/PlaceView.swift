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

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var onHeartButtonTapped: ((_ liked: Bool) -> Void)?
    
    func removePadding() {
        bottomConstraint.constant = 0
        topConstraint.constant = 0
        leadingConstraint.constant = 0
        trailingConstraint.constant = 0
    }
    
    @IBAction func heartButtonTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        onHeartButtonTapped?(button.isSelected)
    }
    
}
