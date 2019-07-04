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

    @IBOutlet var breweryType: UILabel!

    @IBOutlet var breweryAddress: UILabel!

    @IBOutlet var breweryNumber: UILabel!

    @IBOutlet var breweryWebsite: UILabel!

    var brewery: Brewery?

    override func viewDidLoad() {
        super.viewDidLoad()
        if brewery == nil{
            return
            //place error message here
        }
        else{
            SetBreweryData(breweryData: brewery!)
        }
    }
    
    func SetBreweryData(breweryData: Brewery){
        
        breweryTitle.text = breweryData.name
        breweryType.text = "Brewery Type: " + breweryData.brewery_type
        breweryNumber.text = "Number: " +  breweryData.phone
        breweryWebsite.text = breweryData.website_url
        breweryAddress.text = breweryData.city + "," + breweryData.state + " " + breweryData.street + " " + breweryData.postal_code

    }
}
