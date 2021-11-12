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

final class PlaceViewModel {
    private let model: Place
    
    var name: String {
        return model.name
    }
    
    var rating: Int {
        return Int(model.rating)
    }
    
    var numberOfRatings: String {
        return "(\(model.numberOfRatings))"
    }
    
    var priceAndSupportingText: String? {
        guard let priceLevel = model.priceLevel else {
            return model.vicinity
        }
        
        let temp = String(repeating: "$", count: priceLevel.rawValue)
        
        return "\(temp) • \(model.vicinity)"
    }
    
    init(model: Place) {
        self.model = model
    }
}

final class PlaceCellController: NSObject, UITableViewDataSource {
    private let viewModel: PlaceViewModel
    private var cell: PlaceTableViewCell?
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as? PlaceTableViewCell
        
        cell?.name = viewModel.name
        cell?.numberOfRatings = viewModel.numberOfRatings
        cell?.priceAndDetail = viewModel.priceAndSupportingText
        updateCellStarRating()
        
        return cell!
    }
    
    private func updateCellStarRating() {
        let imageName: String
        
        switch viewModel.rating {
        case 0:
            imageName = "1Stars"
        case 2:
            imageName = "2Stars"
        case 3:
            imageName = "3Stars"
        case 4:
            imageName = "4Stars"
        case 5:
            imageName = "5Stars"
        default:
            imageName = "1Stars"
        }
        
        cell?.setStarRating(with: UIImage(named: imageName))
    }
}
