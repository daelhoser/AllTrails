//
//  RootViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import UIKit

final class RootViewController: UIViewController {
    lazy var loader: PlaceLoader = {
        let client = URLSessionHTTPClient(session: URLSession.shared)
        let loader = RemotePlaceLoader(client: client)
        
        return MainQueueDispatcherDecorator(decoratee: loader)
    }()

    lazy var listViewController: PlacesTableViewController = {
        let client = URLSessionHTTPClient(session: .shared)
        let loader = RemoteDataLoader(client: client)
        return PlaceViewComposer.compose(with: loader)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(listViewController)
        view.insertSubview(listViewController.view, at: 0)
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadMockData()
    }
    
    // MARK: - Helper Methods

    private func loadMockData() {
        let location = LocationCoordinate(latitude: 2020, longitude: 2020)
        _ = loader.load(with: Request(keyword: nil, coordinates: location, radius: 0, type: "")) { [weak self] (result) in
            switch result {
            case .failure:
                self?.listViewController.update(with: [])
            case let .success(places):
                self?.listViewController.update(with: places)
            }
        }
    }
}
