//
//  PlacesTableViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/11/21.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        // Configure the cell...

        return cell
    }

 
}
