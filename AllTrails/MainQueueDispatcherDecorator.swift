//
//  MainQueueDispatcherDecorator.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import Foundation

final class MainQueueDispatcherDecorator<T>{
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    private func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatcherDecorator: PlaceLoader where T == PlaceLoader {
    func load(with request: Request, completion: @escaping (PlaceLoader.Result) -> Void) -> RequestTask {
        return decoratee.load(with: request) { [weak self] (result) in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatcherDecorator: DataLoader where T == DataLoader {
    func request(from url: URL, completion: @escaping (DataLoader.Result) -> Void) -> RequestTask {
        return decoratee.request(from: url) { [weak self] (result) in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
