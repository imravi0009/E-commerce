//
//  ViewController.swift
//  E-Commerce
//
//  Created by Ravi kumar on 18/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        NetworkManager().fetchArticles(RequestType.fetchAllData) { (response, err) in
            if let er = err{
                print(er)
            }
            else if let res = response as?  [String:Any]{
                DataStoring().writeDataLocallyFor(json: res)
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let dataManager = DataManager(context: context)
                print(dataManager.fetchAllCategories().count)
            }
        }
    }


}

