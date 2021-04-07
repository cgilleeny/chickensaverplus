//
//  NSManagedObject+Relationship.swift
//  AssetProSwift
//
//  Created by Caroline Gilleeny on 6/27/15.
//  Copyright (c) 2015 aValanche eVantage. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObject {
    func addObject(_ value: NSManagedObject, forKey: String) {
        let items = self.mutableSetValue(forKey: forKey);
        items.add(value)
    }
    
    func removeAllObjects(_ forKey: String) {
        let items = self.mutableSetValue(forKey: forKey);
        items.removeAllObjects()
    }
    
    func removeObject(_ value: NSManagedObject, forKey: String) {
        let items = self.mutableSetValue(forKey: forKey);
        items.remove(value)
    }
}
