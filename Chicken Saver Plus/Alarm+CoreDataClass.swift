//
//  Alarm+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/25/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


public class Alarm: NSManagedObject {
    
    class func create(_ moc: NSManagedObjectContext, offset: Int16, sound: String) throws  {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: moc) as! Alarm
        entity.offset = offset as NSNumber!
        entity.sound = sound
        try moc.save()
    }

}
