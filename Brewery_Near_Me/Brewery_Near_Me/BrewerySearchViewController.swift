//
//  ViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BrewerySearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let breweryInstance = BreweryAPI.sharedInstance
    var breweryData = [Brewery]()
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
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
        if stateLabel.text == defaultTextLabel {
            return
                // place alert to user here
        }
        breweryInstance.fetchBreweries(state: stateLabel.text!, completion: { result in
            switch result {
            case let .success(data):
                self.changeViewController(breweryData: data)
            case let .failure(error):
                print(error)
            }
        })
    }

    func changeViewController(breweryData: [Brewery]) {
        let breweryTableViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryTableViewController") as! BreweryTableViewController
        breweryTableViewController.breweryData = breweryData
        navigationController?.pushViewController(breweryTableViewController, animated: true)
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
        stateLabel.text = states[row]
    }

    // Move to next view controller
}
