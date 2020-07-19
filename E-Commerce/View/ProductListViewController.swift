//
//  ProductListViewController.swift
//  E-Commerce
//
//  Created by Ravi kumar on 19/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import UIKit
import CoreData
class ProductListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var categorTitle = ""
    var products = [Product]()
    var rankings = [Ranking]()
    var isFiltered = false
    var dataManager : DataManager {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return DataManager(context: context)
    }
    var filterIndexSelected = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categorTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterProducts))
        rankings = dataManager.fetchAllRankings()
    }
    @objc func filterProducts() {
        
        var actions: [(String, UIAlertAction.Style)] = []
        
        for rank in rankings {
            actions.append((rank.name ?? ""  , UIAlertAction.Style.default))
        }
        actions.append(("Clear", UIAlertAction.Style.default))
        actions.append(("Cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "Select Ranking option", message: "", actions: actions) { [unowned self] (index) in
            if self.rankings.count > index{
                self.filterIndexSelected = index
                self.isFiltered = true
                self.collectionView.reloadData()
            }
            else if self.rankings.count == index{
                self.isFiltered = false
                self.collectionView.reloadData()
            }
        }
    }
}


extension ProductListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        let product = self.products[indexPath.row]
        
        //let data = self.data[indexPath.item]
        cell.productTitleLable.text = product.name
        if let variant = product.variants?.allObjects.first as? Variant{
            let cost = variant.price + variant.price*product.taxAmount/100
            cell.productPriceLable.text = "$" + String(format: "%.1f", cost)
        }
        else{
            cell.productPriceLable.text = ""
        }
        
        if isFiltered{
            let ranking = rankings[filterIndexSelected]
            if let ranking_product = ranking.products?.allObjects as? [RankingProduct]{
                
            }
        }
        else{
            
        }
        
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let controller = self.productDetailsViewController()
        controller.product = product
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.view.bounds.width/2.0)
        return CGSize(width: self.view.bounds.width/2.0 - 10, height: 120)
    }
}




class ProductCollectionCell: UICollectionViewCell {
    @IBOutlet weak var productTitleLable:UILabel!
    @IBOutlet weak var productPriceLable:UILabel!
    @IBOutlet weak var productRankingLable:UILabel!
}
