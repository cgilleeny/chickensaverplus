//
//  Alarm+CoreDataProperties.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 11/9/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var ext: String?
    @NSManaged public var offset: NSNumber?
    @NSManaged public var sound: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var uuid: String?

}
