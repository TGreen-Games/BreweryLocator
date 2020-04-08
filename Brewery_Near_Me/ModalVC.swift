//
//  ModalVC.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 9/21/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

protocol filterSelected {
    func sendSelection(breweryTypeSelected: BreweryType)
}

class ModalVC: UIViewController {
    private let locationManager = LocationManager()

    var delegate: filterSelected?

    let breweryInstance = BreweryAPI.sharedInstance

    var breweryData = [Brewery]()

    @IBOutlet var modalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.layer.cornerRadius = 20
        modalView.layer.masksToBounds = true
        modalView.layoutMargins.top = 50

        // Do any additional setup after loading the view.
    }
}

extension ModalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return BreweryType.allCases.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "filterCell")
        cell.textLabel?.text = BreweryType.allCases[indexPath.row].rawValue.capitalized

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBreweryType = BreweryType.allCases[indexPath.row].self
        delegate?.sendSelection(breweryTypeSelected: selectedBreweryType)

//        if indexPath.row == breweryTypes.lastIndex(of: "All") {
//            delegate?.sendSelection(selectionTitle: breweryTypes[indexPath.row], selectionValue: nil)
//        } else {
//            delegate?.sendSelection(selectionTitle: breweryTypes[indexPath.row], selectionValue: indexPath.row)
//        }
    }
}
