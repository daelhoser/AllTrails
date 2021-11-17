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
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var listContainerView: UIView!

    var listViewController: PlacesTableViewController!
    var mapViewController: MapViewController!
    var onSearchButtonTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        addView(mapViewController, to: mapContainerView)
        addView(listViewController, to: listContainerView)
        listViewController.view.isHidden = true
        filterButton.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        filterButton.layer.cornerRadius = 6.0
        filterButton.layer.borderWidth = 1.0
        
        mapViewController.onUpdate = { [weak listViewController] (places) in
            listViewController?.update(with: places)
        }
    }
    
    @IBAction func onSearchButtonTap() {
        onSearchButtonTapped?()
    }
    
    @IBAction func flipButtonTapped(_ button: UIButton) {
        let viewToHide = !button.isSelected ? listViewController.view! : mapViewController.view!
        let viewToRender = !button.isSelected ? mapViewController.view! : listViewController.view!
        let containerToRender = !button.isSelected ? mapContainerView! : listContainerView!
        let flipAnimation = !button.isSelected ? UIView.AnimationOptions.transitionFlipFromRight : UIView.AnimationOptions.transitionFlipFromLeft
        button.isSelected = !button.isSelected
        button.isEnabled = false
        
        let transitionOptions: UIView.AnimationOptions = [flipAnimation]

        UIView.transition(from: viewToHide, to: viewToRender, duration: 0.3, options: transitionOptions) { _ in
            viewToHide.isHidden = true
            viewToRender.isHidden = false
            viewToRender.alignTo(parent: containerToRender)
            button.isEnabled = true
        }
    }
    
    // MARK: - Helper Methods
    
    private func addView(_ viewController: UIViewController, to containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.alignTo(parent: containerView)
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
