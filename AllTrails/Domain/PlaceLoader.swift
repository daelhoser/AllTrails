//
//  PlaceLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/10/21.
//

import Foundation

protocol PlaceLoader {
    func load(with request: Request, completion: @escaping (Result<[Place], Error>) -> Void)
}
