//
//  FilterViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 12/4/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

protocol scopeButtonPressed {
    func scopeChanged(selectionCatagory: BreweryType)
}

class FilterViewController: UIViewController, filterSelected {
    @IBOutlet var filterButton: UIButton!
    private var shadowLayer: CAShapeLayer!
    let searchController = UISearchController(searchResultsController: nil)
    var delegate: scopeButtonPressed?
    @IBOutlet var filterView: UIView!
    var currentCatagorySelected: BreweryType!
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.clipsToBounds = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.hidesNavigationBarDuringPresentation = false
        filterView.addSubview(searchController.searchBar)
        filterView.subviews.last?.layer.cornerRadius = 15
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -5

        navigationItem.leftBarButtonItems = [negativeSpacer]

        filterView.layer.shadowColor = UIColor.black.cgColor
        filterView.layer.shadowOffset = .zero
        filterView.layer.shadowOpacity = 0.5
        filterView.layer.shadowRadius = 10.0
        filterView.layer.shadowPath = UIBezierPath(rect: filterView.bounds).cgPath
        filterView.layer.shouldRasterize = true
        currentCatagorySelected = BreweryType.all
        filterButton.setTitle(currentCatagorySelected.rawValue.capitalized, for: .normal)
        searchController.searchBar.sizeToFit()

    }

    @IBAction func filterBreweryType(_: Any) {
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalVC") as! ModalVC
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .fullScreen
        present(modalVC, animated: true, completion: nil)
    }

    func sendSelection(breweryTypeSelected: BreweryType) {
        filterButton.setTitle(breweryTypeSelected.rawValue.capitalized + ">", for: .normal)
        currentCatagorySelected = breweryTypeSelected
        delegate?.scopeChanged(selectionCatagory: breweryTypeSelected)
        dismiss(animated: true, completion: nil)
    }
}
