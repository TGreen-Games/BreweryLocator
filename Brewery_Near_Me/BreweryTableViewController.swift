//
//  BreweryListScreen.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 6/12/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

class BreweryTableViewController: UIViewController {
    var breweryData = [Brewery]()
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let breweryTabBarController = tabBarController as! BreweryTabBarController
        breweryData = breweryTabBarController.breweryData
        // Do any additional setup after loading the view.
    }
}

extension BreweryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return breweryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brewery = breweryData[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryCell") as! BreweryCell

        cell.setBrewery(brewery: brewery)

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breweryViewController = storyboard?.instantiateViewController(withIdentifier: "BreweryViewController") as! BreweryViewController
        breweryViewController.brewery = breweryData[indexPath.row]
        navigationController?.pushViewController(breweryViewController, animated: true)
    }
}
