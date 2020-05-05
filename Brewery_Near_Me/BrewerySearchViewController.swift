//
//  ViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import CoreLocation
import UIKit

class BrewerySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    let breweryInstance = BreweryAPI.sharedInstance
    var breweryData = [Brewery]()
    var filteredStates = [String]()
    var titleView = TitleViewController()
    var isFiltering: Bool {
        return resultSearchController.isActive && isSearchBarEmpty == false
    }

    @IBOutlet var searchView: UIView!
    @IBOutlet var HopHereImage: UIImageView!
    @IBOutlet var stateTableView: StateTableView!
    private let locationManager = LocationManager()
    let resultSearchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return resultSearchController.searchBar.text?.isEmpty ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: stateTableView.frame.width, height: 50)

        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search State..."
        resultSearchController.searchBar.clipsToBounds = false
        resultSearchController.searchBar.searchBarStyle = .prominent
        headerView.addSubview(resultSearchController.searchBar)
        stateTableView.tableHeaderView = headerView
        stateTableView.tableHeaderView?.layer.cornerRadius = 15
        stateTableView.layer.shadowColor = UIColor.black.cgColor
        stateTableView.layer.shadowOffset = .zero
        stateTableView.layer.shadowOpacity = 0.5
        stateTableView.layer.shadowRadius = 10.0
        stateTableView.layer.cornerRadius = 15
        stateTableView.layer.shadowPath = UIBezierPath(rect: stateTableView.tableHeaderView!.bounds).cgPath
        stateTableView.tableHeaderView?.clipsToBounds = true
        definesPresentationContext = true
        searchView.sendSubviewToBack(HopHereImage)
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 226 / 255.0, green: 180 / 255.0, blue: 53 / 255.0, alpha: 1.0)
    }

    func createQueryString(selectedState: String) {
        breweryData.removeAll()
        if selectedState.isEmpty {
            presentAlertWithTitle(title: "State Not Selected", message: "Please select a state", options: "ok") { _ in
            }
            return
        }
        breweryInstance.fetchBreweries(state: selectedState, completion: { result in
            switch result {
            case let .success(data):
                self.changeViewController(breweryData: data, selectedState: selectedState)
            case let .failure(error):
                self.presentAlertWithTitle(title: "Connection Failed", message: "Unable to reach API. Please check connecection", options: "Ok", completion: { _ in
                })
                print(error)
            }
        })
    }

    func changeViewController(breweryData: [Brewery], selectedState: String) {
        let breweryTableViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryTableViewController") as! BreweryTableViewController
        definesPresentationContext = true
        breweryTableViewController.breweryData = breweryData
        breweryTableViewController.selectedState = selectedState
        navigationController?.pushViewController(breweryTableViewController, animated: true)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if isFiltering {
            return filteredStates.count
        }
        return stateTableView.states.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateTableView.dequeueReusableCell(withIdentifier: "StateCell") as! StateCell
        if isFiltering {
            cell.stateLabel.text = filteredStates[indexPath.row].localizedUppercase
        } else {
            cell.stateLabel.text = stateTableView.states[indexPath.row].localizedUppercase
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        createQueryString(selectedState: stateTableView.states[indexPath.row])
    }
}

// Modal Delegate
extension BrewerySearchViewController {
    func changeViews(state: String, data: [Brewery]) {
        dismiss(animated: true, completion: nil)
        let breweryTabController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! BreweryTabBarController
        definesPresentationContext = true
        breweryTabController.breweryData = data
        breweryTabController.selectedState = state
        navigationController?.pushViewController(breweryTabController, animated: true)
    }
}

// Search Bar methods
extension BrewerySearchViewController {
    func updateSearchResults(for _: UISearchController) {
        filterSearchController(searchBar: resultSearchController.searchBar)
    }

    func filterSearchController(searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""

        filteredStates = stateTableView.states.filter { state in
            state.contains(searchText)
        }

        stateTableView.reloadData()
    }
}
