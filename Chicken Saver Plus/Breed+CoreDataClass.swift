//
//  Breed+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/13/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


struct BreedConstants {
    static let availability = "availability"
    static let brooding = "brooding"
    static let coldTolerant = "coldTolerant"
    static let comb = "comb"
    static let confinement = "confinement"
    static let eggSize = "eggSize"
    static let fancy = "fancy"
    static let heatTolerant = "heatTolerant"
    static let maturing = "maturing"
    static let name = "name"
    static let personality = "personality"
    static let productivity = "productivity"
    static let purpose = "purpose"
    static let standardWeight = "standardWeight"
    static let bantamWeight = "bantamWeight"
    static let type = "type"
    static let eggColors = "eggColors"
    static let varieties = "varieties"
    static let specialAttributes = "specialAttributes"
}

struct PurposeConstants {
    static let layer = "Layer"
    static let dualPurpose = "Dual Purpose"
    static let game = "Game"
    static let display = "Display"
    static let notAvailable = "N/A"
}

struct AvailabilityConstants {
    static let common = "Common"
    static let uncommon = "Uncommon"
    static let rare = "Rare"
    static let extinct = "Extinct"
    static let notAvailable = "N/A"
}

struct ProductivityConstants {
    static let average = "Average"
    static let belowAvg = "Below Avg."
    static let aboveAvg = "Above Avg."
    static let notAvailable = "N/A"
}

struct PersonalityConstants {
    static let docile = "Docile"
    static let agressive = "Aggressive"
    static let active = "Active"
    static let notAvailable = "N/A"
}

struct CombConstants {
    static let pea = "Pea"
    static let single = "Single"
    static let theV = "The V"
    static let rose = "Rose"
    static let buttercup = "Buttercup"
    static let cushion = "Cushion"
    static let strawberry = "Strawberry"
    static let carnation = "Carnation"
    static let walnut = "Walnut"
    static let notAvailable = "N/A"
}

struct EggSizeConstants {
    static let medium = "Med."
    static let large = "Large"
    static let tiny = "Tiny"
    static let small = "Small"
    static let extraLarge = "X-Large"
    static let notAvailable = "N/A"
}


struct BroodingConstants {
    static let occasional = "Occasional"
    static let rare = "Rare"
    static let frequent = "Frequent"
    static let nonSetter = "Non-Setter"
    static let extraLarge = "X-Large"
    static let notAvailable = "N/A"
}

struct MaturingConstants {
    static let early = "Early"
    static let average = "Average"
    static let slow = "Slow"
    static let veryEarly = "Very Early"
    static let difficultToRear = "Difficult To Rear"
    static let notAvailable = "N/A"
}

public class Breed: NSManagedObject {
    class func createWithoutSave(_ moc: NSManagedObjectContext, dictionary: Dictionary<String, AnyObject>) throws {
        let entity: Breed = NSEntityDescription.insertNewObject(forEntityName: "Breed", into: moc) as! Breed
        
        entity.availability = dictionary[BreedConstants.availability] as? String ?? ""
        entity.brooding = dictionary[BreedConstants.brooding] as? String ?? ""
        

        if let coldTolerant = dictionary[BreedConstants.coldTolerant] as? NSNumber {
            if coldTolerant == 1 {
                entity.coldTolerant = "Yes"
            } else {
                entity.coldTolerant = "No"
            }
        } else {
            entity.coldTolerant = "N/A"
        }
        
        if let heatTolerant = dictionary[BreedConstants.heatTolerant] as? NSNumber {
            if heatTolerant == 1 {
                entity.heatTolerant = "Yes"
            } else {
                entity.heatTolerant = "No"
            }
        } else {
            entity.heatTolerant = "N/A"
        }
        
        entity.comb = dictionary[BreedConstants.comb] as? String ?? ""
        
        if let confinement = dictionary[BreedConstants.confinement] as? NSNumber {
            if confinement == 1 {
                entity.confinement = "Yes"
            } else {
                entity.confinement = "No"
            }
        } else {
            entity.confinement = "N/A"
        }
        
        entity.eggSize = dictionary[BreedConstants.eggSize] as? String ?? ""
        
        if let fancy = dictionary[BreedConstants.fancy] as? NSNumber {
            if fancy == 1 {
                entity.fancy = "Yes"
            } else {
                entity.fancy = "No"
            }
        } else {
            entity.fancy = "N/A"
        }
        
        if let purpose = dictionary[BreedConstants.purpose] as? String {
            entity.purpose = purpose
        }
        
        entity.maturing = dictionary[BreedConstants.maturing] as? String ?? ""
        entity.name = dictionary[BreedConstants.name] as? String ?? ""
        entity.personality = dictionary[BreedConstants.personality] as? String ?? ""
        entity.productivity = dictionary[BreedConstants.productivity] as? String ?? ""
        
        entity.standardWeight = dictionary[BreedConstants.standardWeight] as? String ?? ""
        entity.bantamWeight = dictionary[BreedConstants.bantamWeight] as? String ?? "N/A"

        entity.type = dictionary[BreedConstants.type] as? String ?? ""
        //@NSManaged var eggColors: EggColor?
        //@NSManaged var specialAttributes: SpecialAttribute?
        //@NSManaged var varieties: Variety?
        
        if let eggColors = dictionary[BreedConstants.eggColors] as? [String] {
            print("dictionary[BreedConstants.name]: \(String(describing: dictionary[BreedConstants.name])), eggColors: \(eggColors)")
            if eggColors.count > 0 {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"EggColor")
                let predicate = NSPredicate(format: "color in %@", eggColors)
                fetchRequest.predicate = predicate
                
                if let eggEntities = try moc.fetch(fetchRequest) as? [EggColor] {
                    for eggEntity in eggEntities {
                        entity.addToEggColors(eggEntity)
                    }
                }
            }
            //for eggColor in eggColors {


                //let eggEntity = try EggColor.createIfNotExistsWithoutSave(moc, color: eggColor)
                
                //entity.addObject(eggEntity, forKey: BreedConstants.eggColors)
            //}
        }
        
        if let varieties = dictionary[BreedConstants.varieties] as? [String] {
            for variety in varieties {
                let varietyEntity = try Variety.createIfNotExistsWithoutSave(moc, name: variety)
                entity.addToVarieties(varietyEntity)
                //entity.addObject(varietyEntity, forKey: BreedConstants.varieties)
            }
        }
        
        if let specialAttributes = dictionary[BreedConstants.specialAttributes] as? [String] {
            for specialAttribute in specialAttributes {
                let specialAttributeEntity = try SpecialAttribute.createIfNotExistsWithoutSave(moc, attribute: specialAttribute)
                entity.addToSpecialAttributes(specialAttributeEntity)
                //entity.addObject(specialAttributeEntity, forKey: BreedConstants.specialAttributes)
            }
        }
    }

}
