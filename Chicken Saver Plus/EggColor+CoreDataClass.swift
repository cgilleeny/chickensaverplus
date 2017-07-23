//
//  EggColor+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/14/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData



let colors = ["White",
              "Brown",
              "Blue-Green",
              "Blue",
              "Lightly Tinted",
              "Creamy White",
              "Light Brown",
              "Dark Brown",
              "Olive",
              "Dark Olive"]

public class EggColor: NSManagedObject {
    
    
    
    class func createIfNotExistsWithoutSave(_ moc: NSManagedObjectContext, color: String) throws -> EggColor {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"EggColor")
        let predicate = NSPredicate(format: "color == %@", color)
        fetchRequest.predicate = predicate
        
        if let results = try moc.fetch(fetchRequest) as? [EggColor] {
            if results.count > 0  {
                return results[0]
            }
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "EggColor", into: moc) as! EggColor
        entity.color = color
        //try moc.save()
        return entity
    }
    
    class func createAll(_ moc: NSManagedObjectContext) throws  {
        for color in colors {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "EggColor", into: moc) as! EggColor
            entity.color = color
        }
        try moc.save()
    }

}
