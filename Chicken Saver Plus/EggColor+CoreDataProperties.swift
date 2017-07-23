//
//  EggColor+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/14/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


extension EggColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EggColor> {
        return NSFetchRequest<EggColor>(entityName: "EggColor");
    }

    @NSManaged public var color: String?
    @NSManaged public var breed: NSSet?

}

// MARK: Generated accessors for breed
extension EggColor {

    @objc(addBreedObject:)
    @NSManaged public func addToBreed(_ value: Breed)

    @objc(removeBreedObject:)
    @NSManaged public func removeFromBreed(_ value: Breed)

    @objc(addBreed:)
    @NSManaged public func addToBreed(_ values: NSSet)

    @objc(removeBreed:)
    @NSManaged public func removeFromBreed(_ values: NSSet)

}
