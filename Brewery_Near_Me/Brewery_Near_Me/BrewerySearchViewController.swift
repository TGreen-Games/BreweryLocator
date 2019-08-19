//
//  ViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import CoreLocation
import UIKit

class BrewerySearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let breweryInstance = BreweryAPI.sharedInstance
    var breweryData = [Brewery]()
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    var selectedState = " "
    let defaultTextLabel = "Please Select a State"
    let states = ["Alaska",
                  "Alabama",
                  "Arkansas",
                  "American Samoa",
                  "Arizona",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "District of Columbia",
                  "Delaware",
                  "Florida",
                  "Georgia",
                  "Guam",
                  "Hawaii",
                  "Iowa",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Massachusetts",
                  "Maryland",
                  "Maine",
                  "Michigan",
                  "Minnesota",
                  "Missouri",
                  "Mississippi",
                  "Montana",
                  "North Carolina",
                  " North Dakota",
                  "Nebraska",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "Nevada",
                  "New York",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Puerto Rico",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Virginia",
                  "Virgin Islands",
                  "Vermont",
                  "Washington",
                  "Wisconsin",
                  "West Virginia",
                  "Wyoming"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Actions
    @IBAction func CreateQueryString(_: UIButton) {
        breweryData.removeAll()
        if selectedState.isEmpty {
            presentAlertWithTitle(title: "State Not Selected", message: "Please select a state", options: "ok") { _ in
            }
            return
        }
        breweryInstance.fetchBreweries(state: selectedState, completion: { result in
            switch result {
            case let .success(data):
                self.changeViewController(breweryData: data)
            case let .failure(error):
                self.presentAlertWithTitle(title: "Connection Failed", message: "Unable to reach API. Please check connecection", options: "Ok", completion: { _ in
                })
                print(error)
            }
        })
    }

    func changeViewController(breweryData: [Brewery]) {
        let breweryTabController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! BreweryTabBarController
        definesPresentationContext = true
        // let breweryTableViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryTableViewController") as! BreweryTableViewController
        breweryTabController.breweryData = breweryData
        // breweryTableViewController.modalPresentationStyle = .currentContext
        navigationController?.pushViewController(breweryTabController, animated: true)
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return states.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return states[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectedState = states[row]
    }

    func pickerView(_: UIPickerView, attributedTitleForRow row: Int, forComponent _: Int) -> NSAttributedString? {
        let string = states[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
    }

    // Move to next view controller
}
