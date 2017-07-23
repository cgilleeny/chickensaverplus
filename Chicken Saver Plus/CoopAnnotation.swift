//
//  CoopAnnotation.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/5/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import MapKit

class CoopAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
