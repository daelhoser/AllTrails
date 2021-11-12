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
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func request(request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
