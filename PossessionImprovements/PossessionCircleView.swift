import Foundation
import UIKit

public class PossessionCircleView: UIView {
    
    public var colorHome: UIColor = UIColor.greenColor()
    public var colorAway: UIColor = UIColor.blueColor()
    public var possessionHome: Float = 0.4
    public var possessionsDistance: CGFloat = 5
    public var startAngle: Float = -90.0
    public var barHeight: CGFloat = 15
    
    public func update(animated: Bool) {
        UIColor.whiteColor().setFill()
        self.backgroundColor = UIColor.whiteColor()
        let pathRect = UIBezierPath(rect: self.bounds)
        pathRect.fill()
        drawInitial(self.bounds.insetBy(dx: 2, dy: 2))
        drawProgress(self.bounds.insetBy(dx: 2, dy: 2))
    }

    private func bezierPathForArc(rect:CGRect, startAngle:CGFloat, endAngle: CGFloat, width:CGFloat, clockwise: Bool) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: CGPointMake(rect.midX, rect.midY),
            radius: rect.width*0.5 - width/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise)
        
        path.addArcWithCenter(
            CGPointMake(rect.midX, rect.midY),
            radius: rect.width*0.5 - width/2,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: !clockwise)
        
        path.closePath()
        return path
    }
    
    private func layerForPath(path: UIBezierPath, color: CGColor, lineWidth: CGFloat, animated:Bool = false) -> CAShapeLayer {
        let pathLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.backgroundColor = UIColor.clearColor().CGColor
        pathLayer.bounds = self.bounds
        pathLayer.geometryFlipped = true
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = color
        pathLayer.lineWidth = lineWidth
        pathLayer.lineJoin = kCALineJoinBevel
        
        if animated {
            let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 2.0
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            pathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        }
        
        return pathLayer
    }
    
    private func drawInitial(rect: CGRect) {
        let missingAngle = distanceInCircuitToRadians(possessionsDistance, radius: rect.midX)
        let drawStartAngle = degToRad(CGFloat(startAngle))
        
        let pathHome = bezierPathForArc(rect,
                                        startAngle: drawStartAngle + missingAngle/2,
                                        endAngle: drawStartAngle + CGFloat(M_PI) - missingAngle/2,
                                        width: barHeight,
                                        clockwise: true)
        
        let pathAway = bezierPathForArc(rect,
                                        startAngle: drawStartAngle + CGFloat(M_PI) + missingAngle/2,
                                        endAngle: drawStartAngle - missingAngle/2,
                                        width: barHeight,
                                        clockwise: true)
        
        let homePathLayer = layerForPath(pathHome, color: colorHome.CGColor, lineWidth: barHeight)
        self.layer.addSublayer(homePathLayer)
        let awayPathLayer = layerForPath(pathAway, color: colorAway.CGColor, lineWidth: barHeight)
        self.layer.addSublayer(awayPathLayer)
    }
    
    private func drawProgress(rect: CGRect) {
        
        let progressAngle = (possessionHome-0.5) * 360.0
        let clockwise = progressAngle<0
        let drawStartAngle = degToRad(CGFloat(startAngle))
        let drawProgressAngle = degToRad(CGFloat(startAngle - progressAngle))
        let missingAngle = distanceInCircuitToRadians(possessionsDistance, radius: rect.midX)
        
        let lowerPath = bezierPathForArc(rect,
                                        startAngle: drawStartAngle-missingAngle/2,
                                        endAngle: drawProgressAngle-missingAngle/2,
                                        width: barHeight,
                                        clockwise: clockwise)
        
        let higherPath = bezierPathForArc(rect,
                                         startAngle: drawStartAngle+missingAngle/2,
                                         endAngle: drawProgressAngle+missingAngle/2,
                                         width: barHeight,
                                         clockwise: clockwise)
        let progressPath = clockwise ? lowerPath : higherPath
        let clearPath = clockwise ? higherPath : lowerPath
        let color = (progressAngle>0) ? colorHome : colorAway
        let clearPathLayer = layerForPath(clearPath, color: UIColor.whiteColor().CGColor, lineWidth: barHeight+1, animated: true)
        self.layer.addSublayer(clearPathLayer)
        let awayPathLayer = layerForPath(progressPath, color: color.CGColor, lineWidth: barHeight, animated: true)
        self.layer.addSublayer(awayPathLayer)

    }
    
    private func distanceInCircuitToRadians(distance:CGFloat, radius: CGFloat) -> CGFloat {
        // distance-d, radius-r, circle-c, percentOfCircle-p, optput-o
        // c = 2πr
        // p = d/c
        // o = 2πp = 2πd/2πr = d/r
        return distance / radius
    }
    
    private func degToRad(deg: CGFloat) -> CGFloat {
        return deg * CGFloat(M_PI) / 180.0
    }
    
}

