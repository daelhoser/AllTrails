//
//  URLSessionHTTPClient.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

final class URLSessionHTTPClient: HttpClient {
    private let session: URLSession
    
    private struct UnExpectedRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }

    init(session: URLSession) {
        self.session = session
    }
    
    func request(request: URLRequest, completion: @escaping (HttpClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnExpectedRepresentation()))
            }
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}
