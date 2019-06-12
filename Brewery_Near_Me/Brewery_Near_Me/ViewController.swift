//
//  ViewController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/11/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let breweryInstance = BreweryAPI.sharedInstance
    @IBOutlet weak var breweryState: UITextField!
    @IBOutlet weak var breweryCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Actions
    @IBAction func CreateQueryString(_ sender: UIButton) {
        if breweryCity.text != nil{
            breweryInstance.CreateQuery(state: breweryState.text!, city: breweryCity.text!)
        }
        else{
            breweryInstance.CreateQuery(state: breweryState.text!)
        }
       
    }
}



