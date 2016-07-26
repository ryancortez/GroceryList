//
//  CounterView.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/26/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit


class CounterView: UIView {
    
    var counter: Int
    
    override init(frame: CGRect) {
        self.counter = 0
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.counter = 0
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        drawLabel()
        let circleSize = CGSizeMake(self.frame.height/1.5, self.frame.height/1.5)
        let circleCenter = centerView(withSize: circleSize, inParentView: self)
        
        drawCircle(atPoint: circleCenter, withCircleDiameter: circleSize.height, andColor: self.tintColor)
    }
    
    func centerView(withSize size: CGSize, inParentView parentView:UIView) -> CGPoint {
        let originalPoint = CGPointMake(parentView.bounds.width/2, parentView.bounds.height/2)
        let newX = originalPoint.x - (size.width / 2)
        let newY = originalPoint.y - (size.height / 2)
        let newPoint = CGPointMake(newX, newY)
        return newPoint
        
    }
    
    func drawCircle(atPoint point: CGPoint, withCircleDiameter circleDiameter: CGFloat, andColor color: UIColor) {
        let circle = UIBezierPath(ovalInRect: CGRect(x: point.x, y: point.y, width: circleDiameter, height: circleDiameter))
        color.setFill()
        circle.fill()
        circle.closePath()
    }
    
    func drawLabel() {
        let label = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.text = "\(self.counter)"
        label.font = UIFont.systemFontOfSize(18.0)
        self.addSubview(label)
    }
}
