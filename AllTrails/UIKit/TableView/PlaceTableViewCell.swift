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
        
        contentView.addSubview(placeView)
        placeView.translatesAutoresizingMaskIntoConstraints = false
        placeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        placeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
}
