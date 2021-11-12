//
//  RemoteDataLoader.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

private final class RemoteDataLoaderTask: RequestTask {
    private var completion: ((RemoteDataLoader.Result) -> Void)?
    
    var wrapped: HTTPClientTask?
    
    init(_ completion: @escaping (RemoteDataLoader.Result) -> Void) {
        self.completion = completion
    }
    
    func complete(with result: RemoteDataLoader.Result) {
        completion?(result)
    }
    
    func cancel() {
        preventFurtherCompletions()
        wrapped?.cancel()
    }
    
    private func preventFurtherCompletions() {
        completion = nil
    }
}

public final class RemoteDataLoader: DataLoader {
    private let client: HttpClient
    
    enum Error: Swift.Error {
        case connectionError
        case invalidData
    }
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func request(from url: URL, completion: @escaping (DataLoader.Result) -> Void) -> RequestTask {
        let task = RemoteDataLoaderTask(completion)
        let request = URLRequest(url: url)

        task.wrapped = client.request(request: request) { [weak self] (result) in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in Error.connectionError }
                .flatMap { (data, response) in
                    let isValidResponse = response.isOK && data.count > 0
                    return isValidResponse ? .success(data) : .failure(RemoteDataLoader.Error.invalidData)
            })
        }
        
        return task
    }
}
