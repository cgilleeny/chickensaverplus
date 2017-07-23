//
//  Variety+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/14/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


public class Variety: NSManagedObject {
    
    class func createIfNotExistsWithoutSave(_ moc: NSManagedObjectContext, name: String) throws -> Variety {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Variety")
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        if let results = try moc.fetch(fetchRequest) as? [Variety] {
            if results.count > 0  {
                return results[0]
            }
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Variety", into: moc) as! Variety
        entity.name = name
        //try moc.save()
        return entity
    }
}
