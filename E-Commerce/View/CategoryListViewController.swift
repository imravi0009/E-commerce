//
//  ViewController.swift
//  E-Commerce
//
//  Created by Ravi kumar on 18/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import UIKit
import ExpyTableView
class CategoryListViewController: UIViewController {    
    @IBOutlet weak var categoryTableView: ExpyTableView!
    var categories = [Category]()
    var dataManager : DataManager {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return DataManager(context: context)
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        fetchServerData()
        
    }
    
    func fetchServerData() {

        categories = self.fetchSortedLocallCategories()
        if categories.count > 0{
           self.refreshTableContent()
            return
        }
        activityIndicator.startAnimating()
        NetworkManager().fetchArticles(RequestType.fetchAllData) { [unowned self] (response, err) in
            if let er = err{
                print(er)
            }
            else if let res = response as?  [String:Any]{
                DataStoring().writeDataLocallyFor(json: res)
               
                self.categories = self.fetchSortedLocallCategories()
                DispatchQueue.main.async { [unowned self] in
                    self.refreshTableContent()
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
    }
    
    
    func fetchSortedLocallCategories() -> [Category] {
                    
      return  dataManager.fetchAllCategories().sorted(by: { (item1, item2) -> Bool in
            if let str1 = item1.name, let str2 = item2.name{
                return str1 < str2
            }
            return false
        })
    }
    
    func setup() {
        categoryTableView.tableFooterView = UIView()
    }
    
    
    func refreshTableContent()  {
         self.categoryTableView.reloadData()
    }
    
}


//MARK: ExpyTableViewDataSourceMethods
extension CategoryListViewController: ExpyTableViewDataSource {
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryCell.self)) as! CategoryCell
        let category = categories[section]
        cell.titleLabel.text = category.name
        if (category.subCategories?.count ?? 0) > 0{
            cell.accessoryType = .disclosureIndicator
        }
        else{
          cell.accessoryType = .none
        }
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

//MARK: ExpyTableView delegate methods
extension CategoryListViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {

    }
}
extension CategoryListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
        
        let productsVC = self.productListViewController()
        let cate = categories[indexPath.section]
        if indexPath.row == 0 {
            if  (cate.products?.allObjects.count ?? 0) > 0{
                productsVC.categorTitle = cate.name ?? ""
                productsVC.products = cate.products?.allObjects as? [Product] ?? []
                self.navigationController?.pushViewController(productsVC, animated: true)
            }
        }
        else{
            if let subCategory = cate.subCategories?.allObjects[indexPath.row - 1] as? SubCategory, let cate_temp = dataManager.fetchCategoryFor(id: Int(subCategory.id)) {
                productsVC.categorTitle = cate_temp.name ?? ""
                productsVC.products = cate_temp.products?.allObjects as? [Product] ?? []
                self.navigationController?.pushViewController(productsVC, animated: true)
            }
        }
        
    }
}

//MARK: UITableView Data Source Methods
extension CategoryListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.categories[section].subCategories?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubCategoryCell.self)) as! SubCategoryCell
        if let subCategory = categories[indexPath.section].subCategories?.allObjects[indexPath.row - 1] as? SubCategory, let cate = dataManager.fetchCategoryFor(id: Int(subCategory.id)) {
            print(subCategory.id)
            cell.titleLabel.text = cate.name
        }
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

class CategoryCell:UITableViewCell{
    @IBOutlet weak var titleLabel:UILabel!
}

class SubCategoryCell:UITableViewCell{
    @IBOutlet weak var titleLabel:UILabel!

}

