//
//  Day+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/17/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var length: NSNumber?
    @NSManaged public var sunrise: NSDate?
    @NSManaged public var sunset: NSDate?
    @NSManaged public var civilDawn: NSDate?
    @NSManaged public var civilDusk: NSDate?

}
