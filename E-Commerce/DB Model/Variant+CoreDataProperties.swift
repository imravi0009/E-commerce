//
//  Variant+CoreDataProperties.swift
//  E-Commerce
//
//  Created by Ravi kumar on 18/07/20.
//  Copyright © 2020 Ravi kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Variant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variant> {
        return NSFetchRequest<Variant>(entityName: "Variant")
    }

    @NSManaged public var id: Int32
    @NSManaged public var color: String?
    @NSManaged public var size: Int32
    @NSManaged public var price: Float

}
