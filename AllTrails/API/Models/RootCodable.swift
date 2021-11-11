//
//  RootCodable.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

struct RootCodable: Decodable {
    let status: String
    let results: [PlaceCodable]
}
