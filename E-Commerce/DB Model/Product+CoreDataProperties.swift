//
//  Product+CoreDataProperties.swift
//  E-Commerce
//
//  Created by Ravi kumar on 18/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var date_added: String?
    @NSManaged public var taxName: String?
    @NSManaged public var taxAmount: Float
    @NSManaged public var variants: NSSet?

}

// MARK: Generated accessors for variants
extension Product {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: Variant)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: Variant)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
