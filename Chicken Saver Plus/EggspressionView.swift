//
//  EggspressionView.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/30/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class EggspressionView: UIView {

    var eggspression:String!
    
    override func draw(_ rect: CGRect) {
        //let context = UIGraphicsGetCurrentContext()
        //let maxTextRect = rect.insetBy(dx: 10.0, dy: 10.0)
        
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        p.lineBreakMode = .byWordWrapping
        
        //let drawingOptions: NSStringDrawingOptions = [.usesFontLeading]
        var fontSize: CGFloat = rect.width * rect.height * CGFloat(0.0006)
        //print("fontSize: \(fontSize)")
        var fontName: String?
        if let _ = UIFont(name: "Noteworthy-Bold", size: fontSize) {
            fontName = "Noteworthy-Bold"
        } else if let _ = UIFont(name: "ChalkboardSE-Bold", size: fontSize) {
            fontName = "ChalkboardSE-Bold"
        }
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 5, height: 5)
        shadow.shadowBlurRadius = 5
        shadow.shadowColor = AppColor.lightTextColor
        
        //let font: UIFont = (fontName != nil) ? UIFont(name: fontName!, size: fontSize)! :  UIFont.systemFont(ofSize: fontSize)
        var attrString = NSAttributedString(
            string: eggspression,
            attributes: [NSForegroundColorAttributeName : AppColor.darkTextColor, NSShadowAttributeName: shadow, NSFontAttributeName:(fontName != nil) ? UIFont(name: fontName!, size: fontSize)! :  UIFont.systemFont(ofSize: fontSize), NSParagraphStyleAttributeName : p])
        
        var attrStringDynamicLength: CGFloat = 0.0
        
        //var actualRect = attrString.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, context: nil)
        
        attrStringDynamicLength = attrString.height(withConstrainedWidth: rect.width)
        //print("Before where loop - actualRect: \(actualRect), attrStringDynamicLength: \(attrStringDynamicLength)")
        while attrStringDynamicLength > rect.height && fontSize > 4.0 {
            fontSize -= 2.0
            attrString = NSAttributedString(
                string: eggspression,
                attributes: [NSForegroundColorAttributeName : AppColor.darkTextColor, NSShadowAttributeName: shadow, NSFontAttributeName:(fontName != nil) ? UIFont(name: fontName!, size: fontSize)! :  UIFont.systemFont(ofSize: fontSize), NSParagraphStyleAttributeName : p])
            attrStringDynamicLength = attrString.height(withConstrainedWidth: rect.width)
        }
        let actualRect = attrString.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil)
        let drawRect = CGRect(x: rect.minX + ((rect.width - actualRect.width) * CGFloat(0.5)), y: rect.minY + ((rect.height - actualRect.height) * CGFloat(0.5)), width: actualRect.width, height: actualRect.height)
        //context!.setFillColor(UIColor.orange.cgColor)
        //context!.fill(drawRect)
        attrString.draw(in: drawRect)

    }
    

}
