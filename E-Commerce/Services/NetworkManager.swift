//
//  WebService.swift
//  Articles
//
//  Created by Ravi kumar on 15/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import Foundation
import UIKit
enum RequestType {
    case fetchAllData
    
    var url: URL! {
           switch self {
           case .fetchAllData:
            return URL(string: NetworkManager.BASEURL + "json")!
           }
       }
}


class NetworkManager {
    
    static let BASEURL = "https://stark-spire-93433.herokuapp.com/"
    
    fileprivate func load(url: URL, withCompletion completion: @escaping (Data?,Error?) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            completion(data,error)
        })
        task.resume()
    }
    
    func fetchArticles(_ type: RequestType, completion: @escaping (Any?,Error?) -> Void) {
        
        load(url: type.url) { data,err  in
            if let data = data {
                if let json = DataParsing().decodeFrom(data: data){
                    completion(json,nil)
                }
                completion(nil,nil)
            } else {
                completion(nil,err)
            }
        }
    }
}

class DataParsing {
    func decodeFrom(data:Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

class DataStoring {

    func writeDataLocallyFor(json:[String:Any]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataManager = DataManager(context: context)
        
        if let categories = json["categories"] as? [Any]{
            for case let category as [String:Any] in categories {
                guard let id = category["id"] as? Int,let name = category["name"] as? String  else {continue}
               
                let cate_model =  dataManager.createCategory(id: id, name: name)
                
                if let products = category["products"] as? [Any]{
                    for case let product as [String:Any] in  products {

                        guard let id = product["id"] as? Int,let name = product["name"] as? String,let dateAdded = product["date_added"] as? String   else {continue}
                        
                        guard let taxInfo = product["tax"] as? [String:Any],let taxName = taxInfo["name"] as? String,let taxValue = taxInfo["value"] as? Float   else {continue}
                        
                        let product_model = dataManager.createProduct(id: id, name: name, dateAdded: dateAdded, taxName: taxName, taxValue: taxValue)
                        cate_model.addToProducts(product_model)
                        
                        if let variants = product["variants"] as? [Any]{
                            for case let variant as [String:Any] in variants {
                              guard let id = variant["id"] as? Int,let color = variant["color"] as? String,let size = variant["size"] as? Int, let price = variant["price"] as? Float   else {continue}
                                let variant_model = dataManager.createVariant(id: id, price: price, size: Int32(size), color: color)
                                product_model.addToVariants(variant_model)
                            }
                        }
                    }
                }
                if let child_categories = category["child_categories"] as? [Int]{
                    for id in child_categories {
                        let sub_category_model = dataManager.createSubCategory(id: id)
                    cate_model.addToSubCategories(sub_category_model)
                    }
                }
            }
        }
        
        if let rankings = json["rankings"] as? [Any]{
            for case let ranking as [String:Any] in rankings {
                guard let name = ranking["ranking"] as? String else{ continue}
                
                let ranking_model = dataManager.createRanking(name: name)
                
                if let ranking_products = ranking["products"] as? [Any]{
                    for case let prod as [String:Int] in ranking_products {
                        guard let prod_id = prod["id"] else { continue }
                        var count = 0
                        var type = ""
                        if let view_count = prod["view_count"]{
                            count = view_count
                            type = "View"
                        }
                        else if let share_count = prod["shares"]{
                            count = share_count
                            type = "Share"
                        }
                        else if let order_count = prod["order_count"]{
                            count = order_count
                            type = "Order"
                        }

                        let ranking_product_model = dataManager.createRankWiseProductRecord(id: prod_id, count: count, type:type)
                        ranking_model.addToProducts(ranking_product_model)

                        
                    }
                }
            }
        }
        dataManager.saveChanges()
    }
}
