//
//  BreweryScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import FloatingPanel
import MapKit
import UIKit

class BreweryViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var breweryAddress: UITextView!
    @IBOutlet var breweryType: UILabel!
    @IBOutlet var breweryNumber: UITextView!
    var brewery: Brewery?
    let regionRadius: CLLocationDistance = 200
    @IBOutlet var breweryTitle: UILabel!
    @IBOutlet var websiteButton: UIButton!

    @IBOutlet var breweryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        SetBreweryData(breweryData: brewery!)
        breweryView.layer.cornerRadius = 30
        breweryView.layer.shadowColor = UIColor.black.cgColor
        breweryView.layer.shadowOffset = .zero
        breweryView.layer.shadowOpacity = 0.5
        breweryView.layer.shadowRadius = 7.0
        breweryView.layer.shadowPath = UIBezierPath(rect: breweryView.bounds).cgPath
        definesPresentationContext = true
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    func SetBreweryData(breweryData: Brewery) {
        breweryTitle.text = breweryData.name.localizedUppercase
        breweryType.text = breweryData.brewery_type.capitalized + " Brewery"

        if breweryData.phone!.isEmpty {
            breweryNumber.text = "N/A"
        } else {
            breweryNumber.text = breweryData.phone?.toPhoneNumber()
        }
        breweryAddress.text = breweryData.city + "," + breweryData.state + "\n" + breweryData.street + " " + breweryData.postal_code
    }

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

            return pinView
        }
    }


    @IBAction func websiteButton(_: Any) {
        guard let website = brewery?.website_url else { return }
        if let URL = URL(string: website) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func exitButton(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension String {
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}
