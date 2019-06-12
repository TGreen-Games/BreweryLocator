//
//  BreweryListScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryListScreen: UIViewController {
    
    var contactSelected = 0
    let breweryInstance = BreweryAPI.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension BreweryListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweryInstance.breweries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brewery = breweryInstance.breweries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryCell") as! BreweryCell
        
        cell.setBrewery(brewery: brewery)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactSelected = indexPath.row
        performSegue(withIdentifier: "SendData", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SendData") {
            let breweryScreen: BreweryScreen = segue.destination as! BreweryScreen
            breweryScreen.contactIndex = contactSelected
        }
}
    
}
