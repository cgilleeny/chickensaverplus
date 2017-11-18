//
//  Alarm+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/25/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


struct AlarmConstants {
    static let id = "id"
    static let sound = "sound"
    static let offset = "offset"
    static let status = "status"
}

public class Alarm: NSManagedObject {
    
    /*
    class func create(_ moc: NSManagedObjectContext, offset: NSNumber, sound: String) throws  {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: moc) as! Alarm
        entity.offset = offset
        entity.sound = sound
        try moc.save()
    }
     */
    
    
    class func create(_ moc: NSManagedObjectContext, id: Int, dictionary: Dictionary<String, Any>) throws  {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: moc) as! Alarm
        entity.id = NSNumber(value: id)
        entity.sound = dictionary[AlarmConstants.sound] as? String ?? "default"
        entity.offset = 0
        if let offset = dictionary[AlarmConstants.offset] as? Int {
            entity.offset = NSNumber(value: offset)
        }
        try moc.save()
    }
    
    
    class func withOffset(_ moc: NSManagedObjectContext, offset: Int) throws -> Alarm? {
        let fetchRequest : NSFetchRequest<Alarm> = Alarm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "offset == %d", offset)
        
        let alarms :[Alarm] = try moc.fetch(fetchRequest)
        if alarms.count > 0 {
            return alarms[0]
        }
        return nil
    }
    

}
