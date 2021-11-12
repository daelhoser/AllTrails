//
//  PlacesTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlacesTableViewController: UITableViewController {
    lazy var loader: PlaceLoader = {
        let client = URLSessionHTTPClient(session: URLSession.shared)
        
        return RemotePlaceLoader(client: client)
    }()
    private var model = [PlaceCellController]()

    override func viewDidLoad() {
        super.viewDidLoad()

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

 
    // MARK: - Helper Methods
    
    private func loadMockData() {
        let location = LocationCoordinate(latitude: 2020, longitude: 2020)
        _ = loader.load(with: Request(keyword: nil, coordinates: location, radius: 0, type: "")) { [weak self] (result) in
            switch result {
            case .failure:
                self?.update(with: [])
            case let .success(places):
                DispatchQueue.main.async {
                    self?.update(with: places)
                }
            }
        }
    }
    
    private func update(with places: [Place]) {
        let viewModels = places.map { PlaceViewModel.init(model: $0) }
        let controllers = viewModels.map { PlaceCellController.init(viewModel: $0) }
        model.removeAll()
        model.append(contentsOf: controllers)
        
        tableView.reloadData()
    }
}
