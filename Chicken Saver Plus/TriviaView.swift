//
//  TriviaView.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/5/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class TriviaView: UIView {

    var trivia:String!

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        print("rect: \(rect)")
        var card: CGRect?
        var scallopRadius: CGFloat?
        var topScallops: Int = 6
        var sideScallops: Int = 9
        
        if rect.height > rect.width {
            scallopRadius = rect.width / 18
            let insetX = scallopRadius! * 3
            let cardWidth = rect.width - (insetX * 2)
            let cardHeight = cardWidth * 1.5
            let insetY = (rect.height - cardHeight) / 2
            card = rect.insetBy(dx: insetX, dy: insetY)
            //context!.setFillColor(UIColor.orange.cgColor)
            //context!.fill(card!)
        } else {
            topScallops = 9
            sideScallops = 6
            scallopRadius = rect.height / 16
            let insetY = scallopRadius! * 2
            let cardHeight = rect.height - (insetY * 2)
            let cardWidth = cardHeight * 1.5
            let insetX = (rect.width - cardWidth) / 2
            card = rect.insetBy(dx: insetX, dy: insetY)
            //context!.setFillColor(UIColor.red.cgColor)
            //context!.fill(card!)
        }
        
        if let card = card as CGRect?, let scallopRadius = scallopRadius as CGFloat? {
            var center = CGPoint(x: card.origin.x - scallopRadius, y: card.origin.y)
            for _ in 1...topScallops {
                center = CGPoint(x: center.x + 2.0*scallopRadius, y: center.y)
                context!.addArc(center: center, radius: scallopRadius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            }
            
            center = CGPoint(x: center.x + scallopRadius, y: center.y - scallopRadius)
            for _ in 1...sideScallops {
                center = CGPoint(x: center.x, y: center.y + 2.0*scallopRadius)
                context!.addArc(center: center, radius: scallopRadius, startAngle: (3 * .pi)/2, endAngle: .pi/2, clockwise: false)
            }
            
            
            center = CGPoint(x: center.x + scallopRadius, y: center.y + scallopRadius)
            for _ in 1...topScallops {
                center = CGPoint(x: center.x - 2.0*scallopRadius, y: center.y)
                context!.addArc(center: center, radius: scallopRadius, startAngle: 2 * .pi, endAngle: .pi, clockwise: false)
            }
            
            center = CGPoint(x: center.x - scallopRadius, y: center.y + scallopRadius)
            for _ in 1...sideScallops {
                center = CGPoint(x: center.x, y: center.y - 2.0*scallopRadius)
                context!.addArc(center: center, radius: scallopRadius, startAngle: .pi/2, endAngle: (3 * .pi)/2, clockwise: false)
            }
            
            context!.setFillColor(UIColor.white.cgColor)
            context!.fillPath()
            

            
            
            let maxTextRect = card.insetBy(dx: 10.0, dy: 10.0)
            
            let p = NSMutableParagraphStyle()
            p.alignment = .center
            p.lineBreakMode = .byWordWrapping
            
            //let drawingOptions: NSStringDrawingOptions = [.usesFontLeading]
            var fontSize: CGFloat = maxTextRect.width * maxTextRect.height * CGFloat(0.0003)
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
            
            var attrString = NSAttributedString(
                string: trivia,
                attributes: [NSForegroundColorAttributeName : AppColor.darkTextColor, NSShadowAttributeName: shadow, NSFontAttributeName:(fontName != nil) ? UIFont(name: fontName!, size: fontSize)! :  UIFont.systemFont(ofSize: fontSize), NSParagraphStyleAttributeName : p])
            
            var attrStringDynamicLength: CGFloat = 0.0
            
            var actualRect = attrString.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, context: nil)
            
            attrStringDynamicLength = attrString.height(withConstrainedWidth: maxTextRect.width)

            while attrStringDynamicLength > maxTextRect.height && fontSize > 4.0 {
                fontSize -= 2.0
                attrString = NSAttributedString(
                    string: trivia,
                    attributes: [NSForegroundColorAttributeName : AppColor.darkTextColor, NSShadowAttributeName: shadow, NSFontAttributeName:(fontName != nil) ? UIFont(name: fontName!, size: fontSize)! :  UIFont.systemFont(ofSize: fontSize), NSParagraphStyleAttributeName : p])
                attrStringDynamicLength = attrString.height(withConstrainedWidth: maxTextRect.width)
            }
            actualRect = attrString.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, context: nil)
            
            let drawRect = CGRect(x: maxTextRect.minX + ((maxTextRect.width - actualRect.width) * CGFloat(0.5)), y: maxTextRect.minY + ((maxTextRect.height - actualRect.height) * CGFloat(0.5)), width: actualRect.width, height: actualRect.height)

            attrString.draw(in: drawRect)
            
            let path:UIBezierPath  = UIBezierPath(roundedRect: card, byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 10, height: 10))
            
            AppColor.darkTextColor.setStroke()
            path.lineWidth = fontSize/10
            path.stroke()
        }
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
    
    
    func dimensions(withConstrainedHeight height: CGFloat, withConstrainedWidth width: CGFloat) -> CGRect {
        let constraintRect = CGSize(width: width, height: height)
        return boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    }
}
