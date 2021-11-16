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

    var loader: PlaceLoader!
    var listViewController: PlacesTableViewController!
    var onSearchButtonTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        addListView()
        filterButton.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        filterButton.layer.cornerRadius = 6.0
        filterButton.layer.borderWidth = 1.0
        loadMockData()
    }
    
    @IBAction func onSearchButtonTap() {
        onSearchButtonTapped?()
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
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cruise&location=-33.8670522%2C151.1957362&radius=1500&type=restaurant&key=AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk
        let location = LocationCoordinate(latitude: -33.8670522, longitude: 151.1957362)
        _ = loader.load(with: Request(keyword: "cruise", coordinates: location, radius: 1500)) { [weak self] (result) in
            switch result {
            case .failure:
                self?.listViewController.update(with: [])
            case let .success(places):
                self?.listViewController.update(with: places)
            }
        }
    }
}

extension RootViewController: SearchPlaceDelegate {
    func didSelected(place: Place, for viewController: SearchPlaceTableViewController) {
        viewController.dismiss(animated: true) {
            self.textField.text = place.name
            self.listViewController.update(with: [place])
        }
    }
    
    func didCancelledSearch(for viewController: SearchPlaceTableViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
