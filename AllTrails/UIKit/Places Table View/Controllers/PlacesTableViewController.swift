//
//  PlacesTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

final class PlacesTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var model = [PlaceCellController]()
    
    var dataLoader: DataLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
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

    func update(with places: [Place]) {
        let viewModels = places.map { PlaceViewModel.init(model: $0, imageLoader: dataLoader) }
        let controllers = viewModels.map { PlaceCellController.init(viewModel: $0) }
        model.removeAll()
        model.append(contentsOf: controllers)
        
        tableView.reloadData()
    }
}
