//
//  DataLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

protocol DataLoader {
    typealias Result = Swift.Result<Data?, Error>
    func request(from url: URL, completion: @escaping (Result) -> Void) -> RequestTask
}
