//
//  SubCategory+CoreDataProperties.swift
//  E-Commerce
//
//  Created by Ravi kumar on 18/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension SubCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCategory> {
        return NSFetchRequest<SubCategory>(entityName: "SubCategory")
    }

    @NSManaged public var id: Int32
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension SubCategory {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
