//
//  BreweryAPI.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import Foundation

struct Brewery:Decodable{
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

class BreweryAPI:NSObject
{
    static let sharedInstance = BreweryAPI() //creates a singleton for class
    var breweries = [Brewery]()
    
    
    func CreateQuery(state: String, city: String? = nil)
    {
        breweries.removeAll()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openbrewerydb.org"
        components.path = "/breweries"
        if city != nil{
            components.queryItems = [
                URLQueryItem(name: "by_city", value: city),
                URLQueryItem(name: "by_state", value: state)
            ]
        }
        else
        {
            components.queryItems = [
                URLQueryItem(name: "by_state", value: state)
            ]
        }
        
        let url = components.url
        URLSession.shared.dataTask(with: url!) { data,resonse,err in
        guard let data = data else {return}
            do{
                let breweryData = try
                JSONDecoder().decode([Brewery].self, from: data)
                print(breweryData)
                self.breweries = breweryData
            }
            catch{
                print("error", err! )
        }
        }
        .resume()
    }
}
