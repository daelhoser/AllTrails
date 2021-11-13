//
//  RootViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import UIKit

final class RootViewController: UIViewController {
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var filterButton: UIButton!

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

        addListView()
        filterButton.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        filterButton.layer.cornerRadius = 6.0
        filterButton.layer.borderWidth = 1.0
        loadMockData()
    }
    
    // MARK: - Helper Methods
    
    private func addListView() {
        addChild(listViewController)
        view.insertSubview(listViewController.view, at: 0)
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listViewController.view.topAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

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
