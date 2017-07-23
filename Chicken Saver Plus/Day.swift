//
//  Day.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 2/24/16.
//  Copyright © 2016 Caroline Gilleeny. All rights reserved.
//
/*
import Foundation
import CoreData


class Day: NSManagedObject {

    class func create(_ moc: NSManagedObjectContext, date: Date, dictionary: Dictionary<String, AnyObject>) throws -> Day {
        let entity: Day = NSEntityDescription.insertNewObject(forEntityName: "Day", into: moc) as! Day
        
        entity.date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+00:00'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        //dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let sunrise = dictionary["sunrise"] as? String {
            print(sunrise)
            if let sunriseDate = dateFormatter.date(from: sunrise) {
                print(sunriseDate)
                entity.sunrise = sunriseDate
            }
        }
        
        if let sunset = dictionary["sunset"] as? String {
            print(sunset)
            if let sunsetDate = dateFormatter.date(from: sunset) {
                print(sunsetDate)
                entity.sunset = sunsetDate
            }
        }
        
        if let length  = dictionary["day_length"] as? NSNumber {
            entity.length = length
        }

        try moc.save()
        return entity
    }

}
*/
