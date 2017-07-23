//
//  Variety+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/14/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


extension Variety {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variety> {
        return NSFetchRequest<Variety>(entityName: "Variety");
    }

    @NSManaged public var name: String?
    @NSManaged public var breed: NSSet?

}

// MARK: Generated accessors for breed
extension Variety {

    @objc(addBreedObject:)
    @NSManaged public func addToBreed(_ value: Breed)

    @objc(removeBreedObject:)
    @NSManaged public func removeFromBreed(_ value: Breed)

    @objc(addBreed:)
    @NSManaged public func addToBreed(_ values: NSSet)

    @objc(removeBreed:)
    @NSManaged public func removeFromBreed(_ values: NSSet)

}
