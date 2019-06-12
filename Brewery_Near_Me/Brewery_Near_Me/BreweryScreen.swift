//
//  BreweryScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryScreen: UIViewController {

    @IBOutlet weak var breweryTitle: UILabel!
    
    @IBOutlet weak var breweryType: UILabel!
    
    @IBOutlet weak var breweryAddress: UILabel!
    
    @IBOutlet weak var breweryNumber: UILabel!
    
    @IBOutlet weak var breweryWebsite: UILabel!
    
    let breweryInstance = BreweryAPI.sharedInstance
    var contactIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        breweryTitle.text = breweryInstance.breweries[contactIndex].name
        breweryType.text = "Brewery Type: " + breweryInstance.breweries[contactIndex].brewery_type
        breweryNumber.text = "Number: " + breweryInstance.breweries[contactIndex].phone
        breweryWebsite.text = breweryInstance.breweries[contactIndex].website_url
        breweryAddress.text = breweryInstance.breweries[contactIndex].city + "," + breweryInstance.breweries[contactIndex].state + " " + breweryInstance.breweries[contactIndex].street + " " + breweryInstance.breweries[contactIndex].postal_code

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

}
