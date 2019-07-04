//
//  BreweryAPI.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import Foundation

struct Brewery: Decodable {
    let id: Int
    let name: String
    let brewery_type: String
    let street: String
    let city: String
    let state: String
    let postal_code: String
    let phone: String
    let website_url: String
}

class BreweryAPI: NSObject {
    static let sharedInstance = BreweryAPI() // creates a singleton for class

    func fetchBreweries(state: String, completion: @escaping (_ breweries: Result<[Brewery], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openbrewerydb.org"
        components.path = "/breweries"
        components.queryItems = [
            URLQueryItem(name: "by_state", value: state),
        ]

        let url = components.url
        URLSession.shared.dataTask(with: url!) { data, _, err in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let breweryData = try
                        JSONDecoder().decode([Brewery].self, from: data)
                    if breweryData.isEmpty {}
                    print(breweryData)
                    completion(.success(breweryData))
                } catch {
                    completion(Result.failure(err!))
                    print("error", err!)
                }
            }
        }
        .resume()
    }
}
