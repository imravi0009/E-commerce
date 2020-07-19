//
//  ProductDetailsViewController.swift
//  E-Commerce
//
//  Created by Ravi kumar on 19/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import UIKit
import CoreData
class ProductDetailsViewController: UIViewController {
    
    var variant :Variant?
    var product: Product!
    
    @IBOutlet weak var variantButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    var dataManager : DataManager {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return DataManager(context: context)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product.name
        self.productNameLabel.text = product.name
        priceCalcualtion()
    }
    
    @IBAction func changeVariantAction(_ sender: Any) {
        var actions: [(String, UIAlertAction.Style)] = []
        
        if let variants = product.variants?.allObjects as? [Variant]  {
            
            for  variant  in variants{
                var text =  ""
                if let color = variant.color{
                    text = "Color: \(color)"
                }
                if variant.size != 0{
                    text += " ,Size: \(variant.size )"
                }
                actions.append((text , UIAlertAction.Style.default))
            }
            actions.append(("Cancel", UIAlertAction.Style.cancel))
            
            Alerts.showActionsheet(viewController: self, title: "Select variant", message: "", actions: actions) { [unowned self] (index) in
                
                print("call action \(index)")
                if variants.count > index{
                    self.variant = variants[index]
                    self.priceCalcualtion()
                }
                
            }
        }
    }
    
    func priceCalcualtion() {
        if let variant_temp = variant{
            let cost = variant_temp.price + variant_temp.price*product.taxAmount/100
            priceLabel.text = "$" + String(format: "%.1f", cost)
            var text =  ""
            if let color = variant_temp.color{
                text = "Color: \(color)"
            }
            if variant_temp.size != 0{
                text += " ,Size: \(variant_temp.size )"
            }
            self.variantButton.setTitle(text, for: .normal)
        }
        else if let vars = product.variants?.allObjects as? [Variant],let variant_temp = vars.first{
            let cost = variant_temp.price + variant_temp.price*product.taxAmount/100
            priceLabel.text = "$" + String(format: "%.1f", cost)
            var text =  ""
            if let color = variant_temp.color{
                text = "Color: \(color)"
            }
            if variant_temp.size != 0{
                text += " ,Size: \(variant_temp.size )"
            }
            self.variantButton.setTitle(text, for: .normal)
        }
    }
    
    
}
