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
        case .authorizedWhenInUse: print("authorizedWhenInUse") // location authorized
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
                completion(nil)
                return
            }

            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(placemark)
        }
    }
}
