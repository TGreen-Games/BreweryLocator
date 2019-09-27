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
        setImageToLabels(label: breweryNumber, image: #imageLiteral(resourceName: "icons8-phone-24"))
        setImageToLabels(label: breweryAddress, image: #imageLiteral(resourceName: "icons8-address-24"))
        setImageToLabels(label: breweryWebsite, image: #imageLiteral(resourceName: "icons8-website-24"))
    }

    func SetBreweryData(breweryData: Brewery) {
        breweryTitle.text = breweryData.name
        breweryType.text = breweryData.brewery_type + " brewery"
        if breweryData.phone!.isEmpty {
            breweryNumber.text = "N/A"
        } else {
            breweryNumber.text = breweryData.phone?.toPhoneNumber()
        }
        if breweryData.website_url!.isEmpty {
            breweryWebsite.text = "N/A"
        } else {
            breweryWebsite.text = breweryData.website_url!
        }
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

    func setImageToLabels(label: UITextView, image: UIImage) {
        let fullString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        // imageAttachment.image = UIImage(cgImage: (imageAttachment.image?.cgImage)!, scale: image.scale, orientation: UIImage.Orientation.up)

        let imageString = NSAttributedString(attachment: imageAttachment)
        let string = NSAttributedString(string: label.text)

        fullString.append(imageString)
        fullString.append(string)

        label.attributedText = fullString
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
    }
}

extension String {
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}
