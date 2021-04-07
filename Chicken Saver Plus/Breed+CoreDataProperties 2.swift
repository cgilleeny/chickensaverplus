//
//  Breed+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/29/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


extension Breed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breed> {
        return NSFetchRequest<Breed>(entityName: "Breed")
    }

    @NSManaged public var availability: String?
    @NSManaged public var brooding: String?
    @NSManaged public var coldTolerant: String?
    @NSManaged public var comb: String?
    @NSManaged public var confinement: String?
    @NSManaged public var eggSize: String?
    @NSManaged public var fancy: String?
    @NSManaged public var heatTolerant: String?
    @NSManaged public var imageName: String?
    @NSManaged public var maturing: String?
    @NSManaged public var name: String?
    @NSManaged public var personality: String?
    @NSManaged public var productivity: String?
    @NSManaged public var purpose: String?
    @NSManaged public var standardWeight: String?
    @NSManaged public var type: String?
    @NSManaged public var bantamWeight: String?
    @NSManaged public var eggColors: NSSet?
    @NSManaged public var specialAttributes: NSSet?
    @NSManaged public var varieties: NSSet?

}

// MARK: Generated accessors for eggColors
extension Breed {

    @objc(addEggColorsObject:)
    @NSManaged public func addToEggColors(_ value: EggColor)

    @objc(removeEggColorsObject:)
    @NSManaged public func removeFromEggColors(_ value: EggColor)

    @objc(addEggColors:)
    @NSManaged public func addToEggColors(_ values: NSSet)

    @objc(removeEggColors:)
    @NSManaged public func removeFromEggColors(_ values: NSSet)

}

// MARK: Generated accessors for specialAttributes
extension Breed {

    @objc(addSpecialAttributesObject:)
    @NSManaged public func addToSpecialAttributes(_ value: SpecialAttribute)

    @objc(removeSpecialAttributesObject:)
    @NSManaged public func removeFromSpecialAttributes(_ value: SpecialAttribute)

    @objc(addSpecialAttributes:)
    @NSManaged public func addToSpecialAttributes(_ values: NSSet)

    @objc(removeSpecialAttributes:)
    @NSManaged public func removeFromSpecialAttributes(_ values: NSSet)

}

// MARK: Generated accessors for varieties
extension Breed {

    @objc(addVarietiesObject:)
    @NSManaged public func addToVarieties(_ value: Variety)

    @objc(removeVarietiesObject:)
    @NSManaged public func removeFromVarieties(_ value: Variety)

    @objc(addVarieties:)
    @NSManaged public func addToVarieties(_ values: NSSet)

    @objc(removeVarieties:)
    @NSManaged public func removeFromVarieties(_ values: NSSet)

}
