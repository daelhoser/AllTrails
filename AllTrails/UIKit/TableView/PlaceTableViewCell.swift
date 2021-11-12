//
//  PlaceTableViewCell.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlaceTableViewCell: UITableViewCell {
    private lazy var placeView: UIView = {
       let nib = UINib(nibName: "PlaceView", bundle: nil)
        
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }()
    
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
