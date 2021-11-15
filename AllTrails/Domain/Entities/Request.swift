//
//  Request.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/10/21.
//

import Foundation

struct Request {
    let keyword: String?
    let coordinates: LocationCoordinate
    let radius: Int
    let type: String = "restaurant"
}
