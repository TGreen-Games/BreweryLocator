//
//  TitleViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 11/7/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class TitleViewController: UIViewController, sendLocationData {
    @IBOutlet var exploreBeersButton: UIButton!
    let locationManager = LocationManager()
    var localState = " "
    var breweryData = [Brewery]()
    let breweryInstance = BreweryAPI.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 226 / 255.0, green: 180 / 255.0, blue: 53 / 255.0, alpha: 1.0)
        if locationManager.locationAllowed == false {
            sendingLocation(isLocationAllowed: false)
        }
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func viewAnotherState(_: Any) {
        switchToStateController(isLocationAllowed: true)
    }

    @IBAction func exploreLocalBeers(_: Any) {
        createQueryString(selectedState: localState)
    }

    func sendingLocation(isLocationAllowed: Bool) {
        if isLocationAllowed {
            locationManager.getPlace(for: locationManager.exposedLocation!, completion: { placemark in
                self.localState = placemark?.administrativeArea ?? " "
                if self.localState.count == 2 {
                    self.localState = self.locationManager.getFullStateName(stateCode: self.localState)
                }
                self.exploreBeersButton.titleLabel?.text = "EXPLORE BEERS IN \(self.localState.localizedUppercase)"
            })
        } else {
            switchToStateController(isLocationAllowed: isLocationAllowed)
        }
    }

    func switchToStateController(isLocationAllowed: Bool) {
        let brewerySearchController = storyboard?.instantiateViewController(withIdentifier: "BrewerySearchViewController") as! BrewerySearchViewController
        if isLocationAllowed {
            navigationController?.pushViewController(brewerySearchController, animated: true)
        } else {
            let navigationController = UINavigationController(navigationBarClass: UINavigationBar.self, toolbarClass: UIToolbar.self)
            navigationController.setViewControllers([brewerySearchController], animated: true)
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        }
    }

    func checkLocation() {
        locationManager.getPlace(for: locationManager.exposedLocation!, completion: { placemark in
            self.localState = placemark?.administrativeArea ?? " "

        })
    }

    func changeViewController(breweryData: [Brewery], selectedState: String) {
        let breweryTableViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryTableViewController") as! BreweryTableViewController
        definesPresentationContext = true
        breweryTableViewController.breweryData = breweryData
        breweryTableViewController.selectedState = selectedState
        navigationController?.pushViewController(breweryTableViewController, animated: true)
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
}
