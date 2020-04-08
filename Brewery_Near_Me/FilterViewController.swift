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
        searchController.hidesNavigationBarDuringPresentation = false
        // searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(searchController.searchBar)
        filterView.subviews.last?.layer.cornerRadius = 15

        // filterView.layer.cornerRadius = 15
        filterView.layer.shadowColor = UIColor.black.cgColor
        filterView.layer.shadowOffset = .zero
        filterView.layer.shadowOpacity = 0.5
        filterView.layer.shadowRadius = 10.0
        filterView.layer.shadowPath = UIBezierPath(rect: filterView.bounds).cgPath
        filterView.layer.shouldRasterize = true
        currentCatagorySelected = BreweryType.all
        filterButton.setTitle(currentCatagorySelected.rawValue.capitalized, for: .normal)
        // let topConstraint = NSLayoutConstraint(item: searchController.searchBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        // searchController.searchBar.addConstraint(topConstraint)
        // searchController.searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0.5, leading: 0, bottom: 0, trailing: 0)
        searchController.searchBar.sizeToFit()

        // filterView.layoutMargins = UIEdgeInsets(top: 100.0, left: 40, bottom: .zero, right: 40)
        // Do any additional setup after loading the view.
    }

    @IBAction func filterBreweryType(_: Any) {
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalVC") as! ModalVC
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }

    func sendSelection(breweryTypeSelected: BreweryType) {
        filterButton.setTitle(breweryTypeSelected.rawValue.capitalized + ">", for: .normal)
        currentCatagorySelected = breweryTypeSelected
        delegate?.scopeChanged(selectionCatagory: breweryTypeSelected)
        dismiss(animated: true, completion: nil)
    }
}
