//
//  PlaceTableViewCell.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlaceTableViewCell: UITableViewCell {
    static let identifier = "PlaceCell"
    
    private lazy var placeView: PlaceView = {
       let nib = UINib(nibName: "PlaceView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil).first as! PlaceView
    }()
    
    var name: String? {
        get {
            placeView.name.text
        }
        set {
            placeView.name.text = newValue
        }
    }
    
    var numberOfRatings: String? {
        get {
            placeView.numberOfRatings.text
        }
        set {
            placeView.numberOfRatings.text = newValue
        }
    }
    
    var priceAndDetail: String? {
        get {
            placeView.priceAndDetail.text
        }
        set {
            placeView.priceAndDetail.text = newValue
        }
    }

    func setStarRating(with image: UIImage?) {
        placeView.ratingImageView.image = image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9490196078, alpha: 1)
        
        addPlaceView()
        placeView.layer.cornerRadius = 8.0
        placeView.clipsToBounds = true
        placeView.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        placeView.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    private func addPlaceView() {
        contentView.addSubview(placeView)
        placeView.translatesAutoresizingMaskIntoConstraints = false
        placeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0).isActive = true
        placeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0).isActive = true
        placeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0).isActive = true
        placeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0).isActive = true
    }
}
