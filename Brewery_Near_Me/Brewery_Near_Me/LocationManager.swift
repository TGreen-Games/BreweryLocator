//
//  LocationManager.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 7/20/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import CoreLocation
import Foundation

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var city = " "
    var state = " "

    // - API
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Core Location Delegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: print("notDetermined") // location permission not asked for yet
        case .authorizedWhenInUse: print("authorizedWhenInUse")
            locationManager.startUpdatingLocation() // location authorized
        case .authorizedAlways: print("authorizedAlways") // location authorized
        case .restricted: print("restricted") // TODO: handle
        case .denied: print("denied") // TODO: handle
        }
    }
}

// MARK: - Get Placemark

extension LocationManager {
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in

            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                // completion(nil)
                return
            }

            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                // completion(nil)
                return
            }

            completion(placemark)
        }
    }
}

// Turning abbreviations in to full names for brewery API
extension LocationManager {
    func getFullStateName(stateCode: String) -> String {
        switch stateCode {
        case "AL":
            return "Alabama"

        case "AK":
            return "Alaska"

        case "AS":
            return "American Samoa"

        case "AZ":
            return "Arizona"

        case "AR":
            return "Arkansas"

        case "CA":
            return "California"

        case "CO":
            return "Colorado"

        case "CT":
            return "Connecticut"

        case "DE":
            return "Delaware"

        case "DC":
            return "District Of Columbia"

        case "FM":
            return "Federated States Of Micronesia"

        case "FL":
            return "Florida"

        case "GA":
            return "Georgia"

        case "GU":
            return "Guam"

        case "HI":
            return "Hawaii"

        case "ID":
            return "Idaho"

        case "IL":
            return "Illinois"

        case "IN":
            return "Indiana"

        case "IA":
            return "Iowa"

        case "KS":
            return "Kansas"

        case "KY":
            return "Kentucky"

        case "LA":
            return "Louisiana"

        case "ME":
            return "Maine"

        case "MH":
            return "Marshall Islands"

        case "MD":
            return "Maryland"

        case "MA":
            return "Massachusetts"

        case "MI":
            return "Michigan"

        case "MN":
            return "Minnesota"

        case "MS":
            return "Mississippi"

        case "MO":
            return "Missouri"

        case "MT":
            return "Montana"

        case "NE":
            return "Nebraska"

        case "NV":
            return "Nevada"

        case "NH":
            return "New Hampshire"

        case "NJ":
            return "New Jersey"

        case "NM":
            return "New Mexico"

        case "NY":
            return "New York"

        case "NC":
            return "North Carolina"

        case "ND":
            return "North Dakota"

        case "MP":
            return "Northern Mariana Islands"

        case "OH":
            return "Ohio"

        case "OK":
            return "Oklahoma"

        case "OR":
            return "Oregon"

        case "PW":
            return "Palau"

        case "PA":
            return "Pennsylvania"

        case "PR":
            return "Puerto Rico"

        case "RI":
            return "Rhode Island"

        case "SC":
            return "South Carolina"

        case "SD":
            return "South Dakota"

        case "TN":
            return "Tennessee"

        case "TX":
            return "Texas"

        case "UT":
            return "Utah"

        case "VT":
            return "Vermont"

        case "VI":
            return "Virgin Islands"

        case "VA":
            return "Virginia"

        case "WA":
            return "Washington"

        case "WV":
            return "West Virginia"

        case "WI":
            return "Wisconsin"

        case "WY":
            return "Wyoming"
        default:
            return " "
        }
    }
}
