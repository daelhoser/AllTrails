//
//  PlacesTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

class PlacesTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private(set) var model = [PlaceCellController]()
    private let dataLoader: DataLoader
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let viewModels = places.map { PlaceViewModel<UIImage>.init(model: $0, imageLoader: dataLoader) { UIImage(data: $0) } }
        let controllers = viewModels.map { PlaceCellController.init(viewModel: $0) }
        model.removeAll()
        model.append(contentsOf: controllers)
        
        tableView.reloadData()
    }
}
