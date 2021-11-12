//
//  PlacesTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlacesTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    lazy var loader: PlaceLoader = {
        let client = URLSessionHTTPClient(session: URLSession.shared)
        let loader = RemotePlaceLoader(client: client)
        
        return MainQueueDispatcherDecorator(decoratee: loader)
    }()
    private var model = [PlaceCellController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        loadMockData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return model[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    // MARK: - UITableViewDataSourcePrefetching

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { model[$0.row].loadImage() }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { model[$0.row].cancelImageLoad() }
    }

 
    // MARK: - Helper Methods
    
    private func loadMockData() {
        let location = LocationCoordinate(latitude: 2020, longitude: 2020)
        _ = loader.load(with: Request(keyword: nil, coordinates: location, radius: 0, type: "")) { [weak self] (result) in
            switch result {
            case .failure:
                self?.update(with: [])
            case let .success(places):
                self?.update(with: places)
            }
        }
    }
    
    private func update(with places: [Place]) {
        let dataLoader = RemoteDataLoader(client: URLSessionHTTPClient(session: URLSession.shared))
        let viewModels = places.map { PlaceViewModel.init(model: $0, imageLoader: MainQueueDispatcherDecorator(decoratee: dataLoader)) }
        let controllers = viewModels.map { PlaceCellController.init(viewModel: $0) }
        model.removeAll()
        model.append(contentsOf: controllers)
        
        tableView.reloadData()
    }
}
