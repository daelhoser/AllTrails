//
//  HttpClient.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HttpClient {
    typealias Result = Swift.Result<(HTTPURLResponse, Data), Error>

    func request(completion: @escaping (Result) -> Void) -> HTTPClientTask
}
