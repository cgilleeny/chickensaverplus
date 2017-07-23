//
//  Alarm+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/4/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm");
    }

    @NSManaged public var offset: NSNumber?
    @NSManaged public var sound: String?
    @NSManaged public var ext: String?

}
