//
//  SearchPlaceTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/13/21.
//

import UIKit

// TODO; constructor variables need to be included
final class SearchPlaceTableViewController: PlacesTableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    private let searchController = UISearchController(searchResultsController: nil)
    private let placeLoader: PlaceLoader
    private var task: RequestTask?
    
    init(placeLoader: PlaceLoader, dataLoader: DataLoader) {
        self.placeLoader = placeLoader
        super.init(dataLoader: dataLoader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search for a restaurant"
        addCancelButton()
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Search for a restaurant"
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchController.isActive = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    private func addCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc
    private func cancelButtonTapped() {
        task?.cancel()
        task = nil
        searchController.searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != "" else {
            update(with: [])
            return }
        
        searchFor(text: text)
    }

    func presentSearchController(_ searchController: UISearchController) {
        showKeyboardAfterLoadingView()
    }
    
    // MARK: - Helper Methods
    
    private func showKeyboardAfterLoadingView() {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func searchFor(text: String) {
        task?.cancel()
        
        task = placeLoader.load(with: request(with: text)) { [weak self] (result) in
            let places = try? result.get()
            self?.update(with: places ?? [Place]())
        }
    }
    
    private func request(with text: String) -> Request {
        // TODO: Complete
        let location = LocationCoordinate(latitude: 2020, longitude: 2020)

        return Request(keyword: text, coordinates: location, radius: 50, type: "")
    }
}
