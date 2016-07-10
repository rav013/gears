//
//  PossessionBarView.swift
//  Goal8
//
//  Created by Jakub on 07/06/16.
//  Copyright © 2016 Perform Group. All rights reserved.
//

import Foundation
import UIKit

public class PossessionBarView: UIView, PossessionViewable {
    public var colorHome: UIColor = UIColor.greenColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var colorAway: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var possessionHome: Float = 0.4 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var possessionsDistance: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        UIColor.whiteColor().setFill()
        let pathRect = UIBezierPath(rect: rect)
        pathRect.fill()
        
        let possession = possessionHome
        let width = CGFloat(possession) * rect.width
        
        let pathHome = UIBezierPath(rect: CGRectMake(0, 0, width, rect.height))
        
        colorHome.setFill()
        
        pathHome.fill()
        
        let pathAway = UIBezierPath(
            rect: CGRectMake(width,
                0,
                rect.width-width,
                rect.height))
        
        colorAway.setFill()
        pathAway.fill()
        
        let extendedPath = UIBezierPath(
            rect: CGRectMake(
                -possessionsDistance,
                -possessionsDistance,
                width+possessionsDistance,
                rect.height+2*possessionsDistance))
        
        extendedPath.lineWidth = possessionsDistance

        UIColor.whiteColor().setStroke()
        extendedPath.stroke()
//        extendedPath.strokeWithBlendMode(CGBlendMode.Clear, alpha: 1.0)
    }
}
