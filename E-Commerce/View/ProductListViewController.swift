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
   private var productWithRanking = [(type:String,count:Int,prod:Product)]()
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
        setupProductWithRanking()
        
    }
    
    func filteredProductsWithRanking() {
        var temp_prods = productWithRanking
        productWithRanking.removeAll()
        if let rnking = rankings[filterIndexSelected].products?.allObjects as? [RankingProduct]{
            for prd in rnking{
                guard let product_temp = getProduct(id: prd.pruduct_id, from: temp_prods) else {continue}
                let item = (type:prd.type ?? "" ,count:Int(prd.count),prod:product_temp)
                productWithRanking.append(item)
                temp_prods.removeAll { (obj) -> Bool in
                    return obj.prod.id == product_temp.id
                }
                
            }
            for prd in temp_prods{
                let item = (type:"",count:0,prod:prd.prod)
                productWithRanking.append(item)
            }
            productWithRanking = productWithRanking.sorted(by: { (item1, item2) -> Bool in
                return item1.count > item2.count
            })
            collectionView.reloadData()
            
        }
    }
    
    func getProduct(id:Int32,from array:[(type:String,count:Int,prod:Product)] ) -> Product? {
       let result =  array.filter { (item) -> Bool in
            return item.prod.id == id
        }
        return result.first?.prod
    }
    
    func setupProductWithRanking() {
         productWithRanking.removeAll()
        for prd in products{
            let item = (type:"",count:0,prod:prd)
            productWithRanking.append(item)
        }
        
        productWithRanking = productWithRanking.sorted(by: { (item1, item2) -> Bool in
            return item1.prod.name! < item2.prod.name!
        })
        collectionView.reloadData()
    }
    
    @objc func filterProducts() {
        
        var actions: [(String, UIAlertAction.Style)] = []
        
        for rank in rankings {
            actions.append(((rank.name ?? "").capitalized  , UIAlertAction.Style.default))
        }
        actions.append(("Clear filtering", UIAlertAction.Style.default))
        actions.append(("Cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "Select Ranking option", message: "", actions: actions) { [unowned self] (index) in
            if self.rankings.count > index{
                self.filterIndexSelected = index
                self.filteredProductsWithRanking()
                self.isFiltered = true
                self.collectionView.reloadData()
            }
            else if self.rankings.count == index{
                self.isFiltered = false
                self.setupProductWithRanking()
                self.collectionView.reloadData()
            }
        }
    }
}


extension ProductListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return productWithRanking.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        let item = self.productWithRanking[indexPath.row]
        let product = item.prod
        
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
            let ranking_name = rankings[filterIndexSelected].name ?? ""
            cell.productRankingLable.text = "\(ranking_name.lowercased().replacingOccurrences(of: "products", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "most", with: "")) by: \(item.count)"
        }
        else{
            cell.productRankingLable.text = ""
        }
        
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productWithRanking[indexPath.row].prod
        let controller = self.productDetailsViewController()
        controller.product = product
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width/2.0 - 10, height: 120)
    }
}




class ProductCollectionCell: UICollectionViewCell {
    @IBOutlet weak var productTitleLable:UILabel!
    @IBOutlet weak var productPriceLable:UILabel!
    @IBOutlet weak var productRankingLable:UILabel!
}
