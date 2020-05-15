//
//  BreweryMap.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 8/14/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import FloatingPanel
import MapKit
import UIKit

class BreweryMap: UIViewController, FloatingPanelControllerDelegate {
    var selectedAnnotationView = MKAnnotationView()
    @IBOutlet var breweryMap: MKMapView!
    var selectedBrewery: Brewery?
    var breweryData = [Brewery]()
    var filteredBreweries = [Brewery]()
    let regionRadius: CLLocationDistance = 10000
    private var filterViewController: FilterViewController!
    @IBOutlet var searchContainer: UIView!
    let fpc = FloatingPanelController()
    var contentVC = BreweryViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        breweryMap.delegate = self
        breweryMap.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        for brewery in breweryData {
            addAnnotation(brewery: brewery)
        }
        if let brewery = selectedBrewery {
            breweryMap.centerMapOnLocation(breweryMap: breweryMap, location: brewery.location!, regionRadius: regionRadius)
        } else {
            breweryMap.centerMapOnLocation(breweryMap: breweryMap, location: breweryData[0].location!, regionRadius: regionRadius)
        }
        navigationController?.navigationBar.barTintColor = .white
        var listImage: UIImage
        var backImage: UIImage
        if #available(iOS 13.0, *) {
            listImage = UIImage(systemName: "list.bullet")!
        } else {
            listImage = #imageLiteral(resourceName: "icons8-list-24") // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            backImage = UIImage(systemName: "chevron.left")!
        } else {
            backImage = #imageLiteral(resourceName: "Forward Arrow")
        }
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToStateSelection))
        let tableButton = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(changeView(sender:)))
        navigationItem.setRightBarButton(tableButton, animated: true)
        navigationItem.setLeftBarButton(backButton, animated: true)
        // navigationItem.title = breweryData[0].state.localizedUppercase

        filterViewController.searchController.searchResultsUpdater = self
        filterViewController.delegate = self

        searchContainer.clipsToBounds = false
        searchContainer.layer.cornerRadius = 10
        searchContainer.layer.shadowColor = UIColor.black.cgColor
        searchContainer.layer.shadowOffset = .zero
        searchContainer.layer.shadowOpacity = 0.5
        searchContainer.layer.shadowRadius = 10.0
        searchContainer.layer.shadowPath = UIBezierPath(rect: searchContainer.bounds).cgPath
        filterViewController.view.clipsToBounds = true
        filterViewController.view.layer.cornerRadius = 20
        fpc.delegate = self
        if let brewery = selectedBrewery {
            let breweryViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryViewController") as! BreweryViewController
            breweryViewController.brewery = brewery
            fpc.set(contentViewController: breweryViewController)
            present(fpc, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            filterViewController.currentCatagorySelected != BreweryType.all
        return
            (filterViewController.isSearchBarEmpty == false || searchBarScopeIsFiltering)
    }

    @objc func changeView(sender _: UIBarButtonItem?) {
        let breweryTable = storyboard?.instantiateViewController(withIdentifier: "BreweryTableViewController") as! BreweryTableViewController
        breweryTable.breweryData = breweryData
        fpc.dismiss(animated: true, completion: nil)
        selectedBrewery = nil
        navigationController?.pushViewController(breweryTable, animated: false)
        navigationController?.popToViewController(breweryTable, animated: true)
    }

    @objc func backToStateSelection(sender _: UIBarButtonItem) {
        fpc.dismiss(animated: true, completion: nil)
        selectedBrewery = nil
        navigationController?.popToRootViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let searchView = segue.destination as? FilterViewController, segue.identifier == "EmbedSegue" {
            filterViewController = searchView
        }
    }

    func addAnnotation(brewery: Brewery) {
        if brewery.location == nil { return }
        let annotation = BreweryAnnotation(brewery: brewery)
        breweryMap.addAnnotation(annotation)
    }
}

// Brewery Map Methods
extension BreweryMap: MKMapViewDelegate {
    // Map Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let pinIdent = "Pin"
            var pinView: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
                pinView.canShowCallout = true
                pinView.image = #imageLiteral(resourceName: "BeerCan")

                let btn = UIButton(type: .detailDisclosure)
                pinView.rightCalloutAccessoryView = btn
            }

            // let subtitleView = UILabel()
            // subtitleView.font = subtitleView.font.withSize(12)
            // subtitleView.numberOfLines = 0
            // subtitleView.text = annotation.subtitle!
            // pinView.detailCalloutAccessoryView = subtitleView
            return pinView
        }
    }

    func mapView(_: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        let breweryViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryViewController") as! BreweryViewController
        let breweryAnnotation = view.annotation as! BreweryAnnotation
        breweryViewController.brewery = breweryAnnotation.brewery
        navigationController?.pushViewController(breweryViewController, animated: true)
    }

    func placeAnnotations() {
        let allAnnotations = breweryMap.annotations
        breweryMap.removeAnnotations(allAnnotations)
        if isFiltering {
            for brewery in filteredBreweries {
                addAnnotation(brewery: brewery)
            }
        } else {
            for brewery in breweryData {
                addAnnotation(brewery: brewery)
            }
        }
    }
}

// SearchBar Methods
extension BreweryMap: UISearchBarDelegate, UISearchResultsUpdating, scopeButtonPressed {
    func scopeChanged(selectionCatagory: BreweryType) {
        let searchTerm = filterViewController.searchController.searchBar.text
        filterContentForSearchText(_searchText: searchTerm!, category: selectionCatagory)
    }

    func filterContentForSearchText(_searchText: String, category: BreweryType) {
        breweryMap.removeAnnotations(breweryMap.annotations)
        filteredBreweries = breweryData.filter { (brewery: Brewery) -> Bool in

            let doesCategoryMatch = category == brewery.breweryTypeEnum

            if filterViewController.isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && brewery.name.lowercased()
                    .contains(_searchText.lowercased())
            }
        }
        placeAnnotations()
    }

    func updateSearchResults(for _: UISearchController) {
        // let searchbar = filterViewController.searchBar
        // let category = filterViewController.currentCategorySelected
        // filterContentForSearchText(_searchText: searchbar!.text!, category: category)
    }
}

extension MKMapView {
    func centerMapOnLocation(breweryMap: MKMapView, location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        breweryMap.setRegion(coordinateRegion, animated: true)
    }
}

final class BreweryAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var brewery: Brewery

    init(brewery: Brewery) {
        coordinate = brewery.location!.coordinate
        title = brewery.name
        self.brewery = brewery

        super.init()
    }
}
