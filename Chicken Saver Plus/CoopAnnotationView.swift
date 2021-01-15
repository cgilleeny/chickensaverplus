//
//  CoopAnnotationView.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/5/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import MapKit

class CoopAnnotationView: MKAnnotationView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
          self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break;
                }
            }
        }
        return isInside;
    }

}
