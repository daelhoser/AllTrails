//
//  UIView+Layout.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/16/21.
//

import Foundation
import UIKit

extension UIView {
    func alignTo(parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
}
