//
//  Extension.swift
//  E-Commerce
//
//  Created by Ravi kumar on 19/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func productListViewController() -> ProductListViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductListController") as! ProductListViewController
        
        return controller
    }
    
    func productDetailsViewController() -> ProductDetailsViewController {
         let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
         
         return controller
     }
    
}


class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for (index, (title, style)) in actions.enumerated() {
        let alertAction = UIAlertAction(title: title, style: style) { (_) in
            completion(index)
        }
        alertViewController.addAction(alertAction)
     }
     viewController.present(alertViewController, animated: true, completion: nil)
    }
}
