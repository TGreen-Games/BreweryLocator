//
//  BreweryAPI.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

struct Brewery: Decodable {
    let id: Int
    let name: String
    let brewery_type: String?
    let street: String
    let city: String
    let state: String
    let postal_code: String
    let longitude: String
    let latitude: String
    let phone: String?
    let website_url: String?
    var distance: Double?

    var location: CLLocation {
        let latValue = Double(latitude)
        let lonValue = Double(longitude)
        return CLLocation(latitude: latValue!, longitude: lonValue!)
    }
}

class BreweryAPI: NSObject {
    static let sharedInstance = BreweryAPI() // creates a singleton for class
    private let locationManager = LocationManager()

    func fetchBreweries(state: String, completion: @escaping (_ breweries: Result<[Brewery], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openbrewerydb.org"
        components.path = "/breweries"
        components.queryItems = [
            URLQueryItem(name: "by_state", value: state),
            // URLQueryItem(name: "sort", value: city),
        ]

        let url = components.url
        URLSession.shared.dataTask(with: url!) { data, _, err in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let breweryData = try
                        JSONDecoder().decode([Brewery].self, from: data)
                    if breweryData.isEmpty { print("No breweries found") }
                    var sortedBreweries = breweryData
                    for brewery in 0 ..< sortedBreweries.count {
                        sortedBreweries[brewery].distance = self.calculateDistance(brewery: sortedBreweries[brewery], localLocation: self.locationManager.exposedLocation)
                    }
                    sortedBreweries.sort(by: { $0.distance! < $1.distance! })
                    completion(.success(sortedBreweries))
                } catch {
                    completion(Result.failure(err!))
                    print("error", err!)
                }
            }
        }
        .resume()
    }

    func calculateDistance(brewery: Brewery, localLocation: CLLocation?) -> Double {
        return brewery.location.distance(from: localLocation!)
    }
}
