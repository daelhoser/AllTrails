//
//  RemotePlaceLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

final class RemotePlaceLoader: PlaceLoader {
    let client: HttpClient
    private let decoder = JSONDecoder()
    typealias Result = PlaceLoader.Result
    
    enum Error: Swift.Error, Equatable {
        case networkError
        case invalidResponse
    }
    
    private class Task: RequestTask {
        private var completion: ((Result) -> Void)?
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (Result) -> Void) {
            self.completion = completion
        }
                
        func cancel() {
            wrapped?.cancel()
            preventFurtherCompletions()
        }
        
        func complete(result: Result) {
            completion?(result)
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    init(client: HttpClient) {
        self.client = client
    }
    
    func load(with request: Request, completion: @escaping (PlaceLoader.Result) -> Void) -> RequestTask {
        let task = Task(completion)
        
        task.wrapped = client.request { [weak self] (data, response, error)  in
            guard let self = self else { return }
            
            if  error != nil {
                completion(.failure(Error.networkError))
                return
            }
            
            completion(self.map(data: data, response: response))
        }
        
        return task
    }
    
    // NOTE: The mapping responsibility shouldn't be part of the loader. We need to move this responsibility elsewhere (MapperClass). This could be done without much fear since we are backed up by tests.
    private func map(data: Data?, response: URLResponse?) -> PlaceLoader.Result {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
            return .failure(Error.invalidResponse)
        }

        if let root = try? self.decoder.decode(RootCodable.self, from: data), root.status == "OK" {
            return .success(root.results.map { $0.toPlace })
        }
            
        return .success([])
    }
}
