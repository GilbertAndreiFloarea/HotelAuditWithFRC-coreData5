//
//  Thing+CoreDataProperties.swift
//  HotelAuditWithFRC-coreData5
//
//  Created by Gilbert Andrei Floarea on 30/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension Thing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thing> {
        return NSFetchRequest<Thing>(entityName: "Thing")
    }

    @NSManaged public var count: Int32
    @NSManaged public var brand: String?
    @NSManaged public var category: String?
    @NSManaged public var imageName: String?

}
