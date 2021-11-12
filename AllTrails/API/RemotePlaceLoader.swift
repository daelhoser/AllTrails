//
//  RemotePlaceLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import Foundation

final class RemotePlaceLoader: PlaceLoader {
    private let baseURLString = "https://maps.googleapis.com/maps/api"
    private let client: HttpClient
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
        
        task.wrapped = client.request(request: createURLRequest(from: request)) { [weak self] (result)  in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                completion(.failure(Error.networkError))
            case let .success((data, response)):
                completion(self.map(data: data, response: response))
            }
        }
        
        return task
    }
    
    // NOTE: The mapping responsibility shouldn't be part of the loader. We need to move this responsibility elsewhere (MapperClass). This could be done without much fear since we are backed up by tests.
    private func map(data: Data?, response: URLResponse?) -> PlaceLoader.Result {
        guard let response = response as? HTTPURLResponse, response.isOK, let data = data else {
            return .failure(Error.invalidResponse)
        }

        if let root = try? self.decoder.decode(RootCodable.self, from: data), root.status == "OK" {
            return .success(root.results.map { $0.toPlace })
        }
            
        return .success([])
    }
    
    private func createURLRequest(from request: Request) -> URLRequest {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cruise&location=-33.8670522%2C151.1957362&radius=1500&type=restaurant&key=AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk" //"\(baseURLString)/place/nearbysearch/json?"
        
        guard let url = URL(string: urlString) else {
            fatalError("Developer Error")
        }
                
        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
