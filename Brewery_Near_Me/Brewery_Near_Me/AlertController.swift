//
//  AlertController.swift
//  Brewery_Near_Me
//
//  Created by Warren Green on 7/5/19.
//  Copyright © 2019 Warren Green. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                completion(index)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
}
