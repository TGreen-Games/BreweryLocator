//
//  BreweryCell.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryCell: UITableViewCell {
    @IBOutlet var breweryName: UILabel!
    @IBOutlet var breweryAddress: UILabel!
    @IBOutlet var breweryNumber: UILabel!

    func setBrewery(brewery: Brewery) {
        breweryName.text = brewery.name
        let cityState = brewery.city + "," + brewery.state
        breweryAddress.text = cityState
        breweryNumber.text = brewery.phone?.toPhoneNumber()
    }
}
