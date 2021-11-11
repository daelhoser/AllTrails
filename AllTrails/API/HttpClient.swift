//
//  HttpClient.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

protocol HttpClient {
    func request(completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
