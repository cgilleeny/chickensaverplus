//
//  SpecialAttribute+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/14/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


public class SpecialAttribute: NSManagedObject {
    class func createIfNotExistsWithoutSave(_ moc: NSManagedObjectContext, attribute: String) throws -> SpecialAttribute {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"SpecialAttribute")
        let predicate = NSPredicate(format: "attribute == %@", attribute)
        fetchRequest.predicate = predicate
        
        if let results = try moc.fetch(fetchRequest) as? [SpecialAttribute] {
            if results.count > 0  {
                return results[0]
            }
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "SpecialAttribute", into: moc) as! SpecialAttribute
        entity.attribute = attribute
        //try moc.save()
        return entity
    }
}
