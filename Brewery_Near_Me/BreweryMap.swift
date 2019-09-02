//
//  BreweryMap.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 8/14/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import MapKit
import UIKit

class BreweryMap: UIViewController {
    var isAlreadySelected = false
    var selectedAnnotationView = MKAnnotationView()
    @IBOutlet var breweryMap: MKMapView!
    var breweryData = [Brewery]()
    let regionRadius: CLLocationDistance = 5000

    override func viewDidLoad() {
        super.viewDidLoad()
        breweryMap.delegate = self
        breweryMap.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let breweryTabController = tabBarController as! BreweryTabBarController
        breweryData = breweryTabController.breweryData
        centerMapOnLocation(location: breweryData[0].location!)
        for brewery in breweryData {
            addAnnotation(brewery: brewery)
        }

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        breweryMap.setRegion(coordinateRegion, animated: true)
    }

    func addAnnotation(brewery: Brewery) {
        if brewery.location == nil { return }
        let annotation = BreweryAnnotation(brewery: brewery)
        breweryMap.addAnnotation(annotation)
    }
}

extension BreweryMap: MKMapViewDelegate {
    // Map Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
                pinView.animatesDrop = true
                pinView.canShowCallout = true
                pinView.pinTintColor = .orange

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
