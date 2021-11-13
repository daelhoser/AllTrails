//
//  RootViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/12/21.
//

import UIKit

final class RootViewComposer {
    private init() {}
    
    static func compose(with loader: PlaceLoader, and dataLoader: DataLoader) -> RootViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController() as! RootViewController
        rootViewController.loader = MainQueueDispatcherDecorator(decoratee: loader)
        rootViewController.listViewController = PlaceViewComposer.compose(with: dataLoader)
        
        return rootViewController
    }
}

final class RootViewController: UIViewController {
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var filterButton: UIButton!

    var loader: PlaceLoader!
    var listViewController: PlacesTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        addListView()
        filterButton.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        filterButton.layer.cornerRadius = 6.0
        filterButton.layer.borderWidth = 1.0
        loadMockData()
    }
    
    @IBAction func onSearchButtonTap() {
        print("Button Tapped")
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
