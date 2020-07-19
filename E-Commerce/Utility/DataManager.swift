//
//  DataManager.swift
//  E-Commerce
//
//  Created by Ravi kumar on 19/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//

import Foundation
import CoreData
class DataManager{
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func createProduct(id:Int, name:String,dateAdded:String,taxName:String,taxValue:Float) -> Product {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
        newItem.id = Int32(id)
        newItem.date_added = dateAdded
        newItem.name = name
        newItem.taxName = taxName
        newItem.taxAmount = taxValue
        return newItem
    }
    
    func createVariant(id:Int, price:Float, size:Int32,color:String) -> Variant {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Variant", into: context) as! Variant
        newItem.id = Int32(id)
        newItem.price = price
        newItem.color = color
        newItem.size = size
        return newItem
    }
    
    func createCategory(id:Int, name:String) -> Category {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        newItem.id = Int32(id)
        newItem.name = name
        return newItem
    }
    
    func createSubCategory(id:Int) -> SubCategory {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "SubCategory", into: context) as! SubCategory
        newItem.id = Int32(id)
        return newItem
    }
    
    func createRanking(name:String) -> Ranking {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Ranking", into: context) as! Ranking
        newItem.name = name
        return newItem
    }
    
    func createRankWiseProductRecord(id:Int, count:Int, type:String) -> RankingProduct {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "RankingProduct", into: context) as! RankingProduct
        newItem.pruduct_id = Int32(id)
        newItem.count = Int32(count)
        newItem.type = type
        return newItem
    }
    
    func fetchAllCategories() -> [Category] {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            do {
                let response = try context.fetch(fetchRequest)
                return response as! [Category]
                
            } catch let error as NSError {
                // failure
                print(error)
                return [Category]()
            }
        }
    }
    
    func fetchCategoryFor(id:Int) -> Category? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id = %ld", id)
            do {
                let response = try context.fetch(fetchRequest)
                return response.first as? Category
            } catch let error as NSError {
                print(error)
                return nil
            }
        }
    }
    
    
    func fetchProductFor(id:Int) -> Product? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id = %ld", id)
            do {
                let response = try context.fetch(fetchRequest)
                return response.first as? Product
            } catch let error as NSError {
                print(error)
                return nil
            }
        }
    }
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
}
