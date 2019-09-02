//
//  BreweryScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryViewController: UIViewController {
    @IBOutlet var breweryTitle: UILabel!

    @IBOutlet var breweryImage: UIImageView!

    @IBOutlet var breweryAddress: UITextView!
    @IBOutlet var breweryWebsite: UITextView!

    @IBOutlet var breweryType: UILabel!
    @IBOutlet var breweryNumber: UITextView!
    var brewery: Brewery?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBreweryPicture()
        if brewery == nil {
            presentAlertWithTitle(title: "Unable To Find Brewery", message: "Please select another one.", options: "Ok", completion: { _ in })
            return
        } else {
            SetBreweryData(breweryData: brewery!)
        }
        breweryAddress.textContainer.maximumNumberOfLines = 1
        breweryNumber.textContainer.maximumNumberOfLines = 1
        breweryWebsite.textContainer.maximumNumberOfLines = 1
    }

    func SetBreweryData(breweryData: Brewery) {
        breweryTitle.text = breweryData.name
        breweryType.text = "Brewery Type: " + breweryData.brewery_type
        breweryNumber.text = breweryData.phone?.toPhoneNumber()
        breweryWebsite.text = breweryData.website_url
        breweryAddress.text = breweryData.city + "," + breweryData.state + " " + breweryData.street + " " + breweryData.postal_code
    }

    func setBreweryPicture() {
        switch brewery?.brewery_type {
        case "micro":
            breweryImage.image = #imageLiteral(resourceName: "micro")
        case "regional":
            breweryImage.image = #imageLiteral(resourceName: "regional")
        case "brewpub":
            breweryImage.image = #imageLiteral(resourceName: "brewpub")
        case "large":
            breweryImage.image = #imageLiteral(resourceName: "large")
        case "bar":
            breweryImage.image = #imageLiteral(resourceName: "bar")
        default:
            breweryImage.image = #imageLiteral(resourceName: "beer-logo-design-brewery-label-on-black-vector-20449420")
        }
    }
}

extension String {
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}
