//
//  BreedDetailView.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/13/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

let rowHeight: CGFloat = 44.0
let horizontalOffset:CGFloat = 5.0
let verticalOffset:CGFloat = 5.0

class BreedDetailView: UIView {

    var breed: Breed!
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.yellow.cgColor)
        context!.fill(rect)
        
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        p.lineBreakMode = .byTruncatingTail

        var rowRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rowHeight*5/4)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        var attrString = NSAttributedString(
            string: breed.purpose ?? "N/A",
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 19.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowHeight*9/8)
        
        context!.move(to: CGPoint(x: rowRect.origin.x, y: rowRect.origin.y))
        context!.addLine(to: CGPoint(x: rowRect.origin.x + rowRect.size.width, y: rowRect.origin.y))
        context!.strokePath()
        
        attrString = NSAttributedString(
            string: "Eggs",
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 17.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowHeight)
        
        //context!.setFillColor(AppColor.textBoxGrey.cgColor)
        //context!.fill(rowRect)
        
        //p.alignment = .left
        
        var propertyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        
        //context!.setFillColor(AppColor.textBoxGrey.cgColor)
        //context!.fill(rowRect)
        
        //p.alignment = .left
        
        attrString = NSAttributedString(
            string: String(format: "Size: %@", breed.eggSize ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        propertyRect = CGRect(x: propertyRect.origin.x + propertyRect.size.width, y: propertyRect.origin.y, width: propertyRect.size.width, height: propertyRect.size.height)
        
        
        attrString = NSAttributedString(
            string: String(format: "Productivity: %@", breed.productivity ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        
        
        if let eggColors = breed.eggColors!.allObjects as? [EggColor] {
            if eggColors.count > 0 {
                p.alignment = .center
                
                attrString = NSAttributedString(
                    string: "Colors",
                    attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                for eggColor in eggColors {
                    rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
                    
                    attrString = NSAttributedString(
                        string: eggColor.color!,
                        attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                    attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                }
            }
        }
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        context!.move(to: CGPoint(x: rowRect.origin.x, y: rowRect.origin.y))
        context!.addLine(to: CGPoint(x: rowRect.origin.x + rowRect.size.width, y: rowRect.origin.y))
        context!.strokePath()
        
        p.alignment = .left
        
        propertyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: String(format: "Personality: %@", breed.personality ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        propertyRect = CGRect(x: propertyRect.origin.x + propertyRect.size.width, y: propertyRect.origin.y, width: propertyRect.size.width, height: propertyRect.size.height)
        
        
        attrString = NSAttributedString(
            string: String(format: "Heat Tolerant: %@", breed.heatTolerant ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        //context!.move(to: CGPoint(x: rowRect.origin.x, y: rowRect.origin.y))
        //context!.addLine(to: CGPoint(x: rowRect.origin.x + rowRect.size.width, y: rowRect.origin.y))
        //context!.strokePath()

        propertyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: String(format: "Availability: %@", breed.availability ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        propertyRect = CGRect(x: propertyRect.origin.x + propertyRect.size.width, y: propertyRect.origin.y, width: propertyRect.size.width, height: propertyRect.size.height)
        
        
        attrString = NSAttributedString(
            string: String(format: "Cold Tolerant: %@", breed.coldTolerant ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        

        
        propertyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: String(format: "Brooding: %@", breed.brooding ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        propertyRect = CGRect(x: propertyRect.origin.x + propertyRect.size.width, y: propertyRect.origin.y, width: propertyRect.size.width, height: propertyRect.size.height)
        
        
        attrString = NSAttributedString(
            string: String(format: "Fancy: %@", breed.fancy ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        
        
        propertyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: String(format: "Maturing: %@", breed.maturing ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        propertyRect = CGRect(x: propertyRect.origin.x + propertyRect.size.width, y: propertyRect.origin.y, width: propertyRect.size.width, height: propertyRect.size.height)
        
        
        attrString = NSAttributedString(
            string: String(format: "Confinement Tolerant: %@", breed.confinement ?? "N/A"),
            attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
        attrString.draw(in: propertyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)

        context!.move(to: CGPoint(x: rowRect.origin.x, y: rowRect.origin.y))
        context!.addLine(to: CGPoint(x: rowRect.origin.x + rowRect.size.width, y: rowRect.origin.y))
        context!.strokePath()
        
        if let varieties = breed.varieties!.allObjects as? [Variety] {
            if varieties.count > 0 {
                p.alignment = .center
                
                attrString = NSAttributedString(
                    string: "Varieties",
                    attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                for variety in varieties {
                    rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
                    
                    attrString = NSAttributedString(
                        string: variety.name!,
                        attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                    attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                }
            }
        }
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        context!.move(to: CGPoint(x: rowRect.origin.x, y: rowRect.origin.y))
        context!.addLine(to: CGPoint(x: rowRect.origin.x + rowRect.size.width, y: rowRect.origin.y))
        context!.strokePath()
        
        
        if let specialAttributes = breed.specialAttributes!.allObjects as? [SpecialAttribute] {
            if specialAttributes.count > 0 {
                p.alignment = .center
                
                attrString = NSAttributedString(
                    string: "Special Attributes",
                    attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                for specialAttribute in specialAttributes {
                    rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
                    
                    attrString = NSAttributedString(
                        string: specialAttribute.attribute!,
                        attributes: [NSAttributedString.Key.font:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSAttributedString.Key.paragraphStyle : p])
                    attrString.draw(in: rowRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
                }
            }
        }

        
        /*
        keyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        valueRect = CGRect(x: rowRect.origin.x + keyRect.size.width, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)

        attrString = NSAttributedString(
            string: NSLocalizedString("Purpose:", comment: ""),
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: keyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        attrString = NSAttributedString(
            string: breed.purpose ?? "N/A",
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: valueRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        keyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        valueRect = CGRect(x: rowRect.origin.x + keyRect.size.width, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        attrString = NSAttributedString(
            string: NSLocalizedString("Productivity:", comment: ""),
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: keyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        attrString = NSAttributedString(
            string: breed.productivity ?? "N/A",
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: valueRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        keyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        valueRect = CGRect(x: rowRect.origin.x + keyRect.size.width, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: NSLocalizedString("Personality:", comment: ""),
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: keyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        attrString = NSAttributedString(
            string: breed.personality ?? "N/A",
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: valueRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        keyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        valueRect = CGRect(x: rowRect.origin.x + keyRect.size.width, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        context!.setFillColor(AppColor.textBoxGrey.cgColor)
        context!.fill(rowRect)
        
        attrString = NSAttributedString(
            string: NSLocalizedString("Availability:", comment: ""),
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: keyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        attrString = NSAttributedString(
            string: breed.availability ?? "N/A",
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: valueRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        rowRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y + rowRect.size.height, width: rowRect.size.width, height: rowRect.size.height)
        
        keyRect = CGRect(x: rowRect.origin.x, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        valueRect = CGRect(x: rowRect.origin.x + keyRect.size.width, y: rowRect.origin.y, width: rowRect.size.width/2.0, height: rowRect.size.height)
        
        attrString = NSAttributedString(
            string: NSLocalizedString("Fancy:", comment: ""),
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p])
        attrString.draw(in: keyRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        
        attrString = NSAttributedString(
            string: breed.fancy ?? "N/A",
            attributes: [NSFontAttributeName:UIFont(name: "Noteworthy-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 13.0), NSParagraphStyleAttributeName : p, NSForegroundColorAttributeName: UIColor.red])
        attrString.draw(in: valueRect.insetBy(dx: horizontalOffset, dy: verticalOffset))
        */
        let path = UIBezierPath.init(rect: rect)
        path.lineWidth = 5.0;
        path.stroke()
    }


}
