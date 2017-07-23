//
//  Day+CoreDataClass.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/17/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


public class Day: NSManagedObject {
    
    class func create(_ moc: NSManagedObjectContext, date: Date, dictionary: Dictionary<String, AnyObject>) throws -> Day {
        let entity: Day = NSEntityDescription.insertNewObject(forEntityName: "Day", into: moc) as! Day
        
        entity.date = date as NSDate?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+00:00'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        //dateFormatter.timeZone = NSTimeZone.localTimeZone()
        if let civilDawn = dictionary["civil_twilight_begin"] as? String {
            if let civilDawnDate = dateFormatter.date(from: civilDawn) {
                print(civilDawnDate)
                entity.civilDawn = civilDawnDate as NSDate?
            }
        }

        if let sunrise = dictionary["sunrise"] as? String {
            if let sunriseDate = dateFormatter.date(from: sunrise) {
                print(sunriseDate)
                entity.sunrise = sunriseDate as NSDate?
            }
        }
        
        if let sunset = dictionary["sunset"] as? String {
            if let sunsetDate = dateFormatter.date(from: sunset) {
                print(sunsetDate)
                entity.sunset = sunsetDate as NSDate?
            }
        }
        
        if let civilDusk = dictionary["civil_twilight_end"] as? String {
            if let civilDuskDate = dateFormatter.date(from: civilDusk) {
                print(civilDuskDate)
                entity.civilDusk = civilDuskDate as NSDate?
            }
        }
        
        if let length  = dictionary["day_length"] as? NSNumber {
            entity.length = length
        }
        
        try moc.save()
        return entity
    }
}
