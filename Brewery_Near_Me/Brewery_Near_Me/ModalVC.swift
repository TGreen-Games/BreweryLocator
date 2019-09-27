//
//  ModalVC.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 9/21/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

protocol DismissDelegate {
    func changeViews(state: String, data: [Brewery])
}

class ModalVC: UIViewController {
    private let locationManager = LocationManager()

    let breweryInstance = BreweryAPI.sharedInstance

    var breweryData = [Brewery]()

    var delegate: DismissDelegate?

    @IBOutlet var modalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.layer.cornerRadius = 20
        modalView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    @IBAction func createLocalQueryString(_: UIButton) {
        locationManager.getPlace(for: locationManager.exposedLocation!, completion: { placemark in
            var localState = placemark?.administrativeArea
            if localState?.count == 2 {
                localState = self.locationManager.getFullStateName(stateCode: localState!)
                self.breweryData.removeAll()
                self.breweryInstance.fetchBreweries(state: localState!, completion: { result in
                    switch result {
                    case let .success(data):
                        self.delegate?.changeViews(state: localState!, data: data)
                    case let .failure(error):
                        self.presentAlertWithTitle(title: "Connection Failed", message: "Unable to reach API. Please check connecection", options: "Ok", completion: { _ in
                        })
                        print(error)
                    }
                })
            }
        })
    }

    @IBAction func dismissView(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func changeViewController(breweryData: [Brewery]) {
        let breweryTabController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! BreweryTabBarController
        definesPresentationContext = true
        breweryTabController.breweryData = breweryData
        breweryTabController.selectedState = locationManager.state
        navigationController?.pushViewController(breweryTabController, animated: true)
    }
}
