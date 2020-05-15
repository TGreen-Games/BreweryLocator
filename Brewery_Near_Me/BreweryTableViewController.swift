//
//  BreweryListScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryTableViewController: UIViewController {
    var breweryData = [Brewery]()
    var filteredBreweries = [Brewery]()
    var selectedState = " "

    @IBOutlet var searchContainer: UIView!
    @IBOutlet var tableView: UITableView!
    private var filterViewController: FilterViewController!

    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            filterViewController.currentCatagorySelected != BreweryType.all
        return
            (filterViewController.isSearchBarEmpty == false || searchBarScopeIsFiltering)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        filterViewController.searchController.searchResultsUpdater = self
        filterViewController.delegate = self
        var mapImage: UIImage
        var backImage: UIImage
        if #available(iOS 13.0, *) {
            mapImage = UIImage(systemName: "map")!
        } else {
            mapImage = #imageLiteral(resourceName: "icons8-map-24") // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            backImage = UIImage(systemName: "chevron.left")!
        } else {
            backImage = #imageLiteral(resourceName: "Forward Arrow")
        }
        navigationController?.navigationBar.barTintColor = .white
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToStateSelection))
        let mapButton = UIBarButtonItem(image: mapImage, style: .plain, target: self, action: #selector(changeView))
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationItem.setRightBarButton(mapButton, animated: true)

        searchContainer.clipsToBounds = false
        searchContainer.layer.cornerRadius = 100
        searchContainer.layer.shadowColor = UIColor.black.cgColor
        searchContainer.layer.shadowOffset = .zero
        searchContainer.layer.shadowOpacity = 0.5
        searchContainer.layer.shadowRadius = 10.0
        searchContainer.layer.shadowPath = UIBezierPath(rect: searchContainer.bounds).cgPath
        filterViewController.view.clipsToBounds = true
        filterViewController.view.layer.cornerRadius = 20

//        navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.font: UIFon t(name: "PhosphateInline", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.title = breweryData[0].state.localizedUppercase
        // Do any additional setup after loading the view.

        // searchContainer.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        print("we in here")
        // filterViewContr oller.view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 50, leading: 10, bottom: 0, trailing: 10)
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let searchView = segue.destination as? FilterViewController, segue.identifier == "EmbedSegue" {
            filterViewController = searchView
        }
    }

    @objc func changeView(sender _: UIBarButtonItem) {
        let breweryMap = storyboard?.instantiateViewController(withIdentifier: "MapController") as! BreweryMap
        breweryMap.breweryData = breweryData
        navigationController?.pushViewController(breweryMap, animated: true)
    }

    @objc func backToStateSelection(sender _: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}

// Search Bar Methods
extension BreweryTableViewController: UISearchBarDelegate, UISearchResultsUpdating, scopeButtonPressed {
    func scopeChanged(selectionCatagory: BreweryType) {
        let searchTerm = filterViewController.searchController.searchBar.text
        filterContentForSearchText(_searchText: searchTerm!, category: selectionCatagory)
    }

    func filterContentForSearchText(_searchText: String, category: BreweryType) {
        filteredBreweries = breweryData.filter { (brewery: Brewery) -> Bool in

            let doesCategoryMatch = category == brewery.breweryTypeEnum

            if filterViewController.isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && brewery.name.lowercased()
                    .contains(_searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    func updateSearchResults(for _: UISearchController) {
        let searchTerm = filterViewController.searchController.searchBar.text
        filterContentForSearchText(_searchText: searchTerm!, category: filterViewController.currentCatagorySelected)
    }
}

// Table View Methods
extension BreweryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if isFiltering {
            return filteredBreweries.count
        } else {
            return breweryData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brewery: Brewery

        let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryCell") as! BreweryCell
        if isFiltering {
            brewery = filteredBreweries[indexPath.row]
        } else {
            brewery = breweryData[indexPath.row]
        }

        cell.setBrewery(brewery: brewery)

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breweryMap = storyboard?.instantiateViewController(withIdentifier: "MapController") as! BreweryMap
        breweryMap.breweryData = breweryData
        breweryMap.selectedBrewery = breweryData[indexPath.row]
        navigationController?.pushViewController(breweryMap, animated: true)
    }
}
