

import UIKit

extension UIView {

    func addSubviewStretchedWithConstantOnHeight(subview: UIView, height: CGFloat) -> NSLayoutConstraint? {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let horizontalFormat = "H:|[subview]|"
        let verticalTopFormat = "V:|[subview(\(height))]"
        let viewsDict = ["subview": subview]

        self.addSubview(subview)

        self.addViewWithLayoutFormat(horizontalFormat, views: viewsDict)
        if let heightConstraints = self.addViewWithLayoutFormat(verticalTopFormat, views: viewsDict) {
            if heightConstraints.count == 2 {
                if heightConstraints.first?.constant == height {
                    return heightConstraints[0]
                } else {
                    return heightConstraints[1]
                }
            }
        }
        return nil
    }
    
    typealias ConstraintsTupleStretched = (top:NSLayoutConstraint, bottom:NSLayoutConstraint, leading:NSLayoutConstraint, trailing:NSLayoutConstraint)
    func addSubviewStretched(subview:UIView?, insets: UIEdgeInsets = UIEdgeInsets() ) -> ConstraintsTupleStretched? {
        guard let subview = subview else {
            return nil
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let constraintLeading = NSLayoutConstraint(item: subview,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: insets.left)
        addConstraint(constraintLeading)
        
        let constraintTrailing = NSLayoutConstraint(item: self,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: subview,
            attribute: .Right,
            multiplier: 1,
            constant: insets.right)
        addConstraint(constraintTrailing)
        
        let constraintTop = NSLayoutConstraint(item: subview,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1,
            constant: insets.top)
        addConstraint(constraintTop)
        
        let constraintBottom = NSLayoutConstraint(item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: subview,
            attribute: .Bottom,
            multiplier: 1,
            constant: insets.bottom)
        addConstraint(constraintBottom)
        return (constraintTop, constraintBottom, constraintLeading, constraintTrailing)
    }
    
    typealias ConstraintsTupleCentered = (centerX:NSLayoutConstraint, centerY:NSLayoutConstraint )
    func addSubviewCentered(subview: UIView?,
                            clipToParentView:Bool = false,
                            insets: UIEdgeInsets = UIEdgeInsets(),
                            offset:CGPoint = CGPoint.zero) -> ConstraintsTupleCentered? {
        guard let subview = subview else {
            return nil
        }
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXContraint = NSLayoutConstraint(item: subview,
                                                  attribute: .CenterX,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterX,
                                                  multiplier: 1.0,
                                                  constant: offset.x)
        addConstraint(centerXContraint)

        let centerYContraint = NSLayoutConstraint(item: subview,
                                                  attribute: .CenterY,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterY,
                                                  multiplier: 1.0,
                                                  constant: offset.y)
        addConstraint(centerYContraint)
        
        if clipToParentView {
            let constraintLeading = NSLayoutConstraint(item: subview,
                                                       attribute: .Left,
                                                       relatedBy: .GreaterThanOrEqual,
                                                       toItem: self,
                                                       attribute: .Left,
                                                       multiplier: 1,
                                                       constant: insets.left)
            addConstraint(constraintLeading)
            
            let constraintTrailing = NSLayoutConstraint(item: self,
                                                        attribute: .Right,
                                                        relatedBy: .GreaterThanOrEqual,
                                                        toItem: subview,
                                                        attribute: .Right,
                                                        multiplier: 1,
                                                        constant: insets.right)
            addConstraint(constraintTrailing)
            
            let constraintTop = NSLayoutConstraint(item: subview,
                                                   attribute: .Top,
                                                   relatedBy: .GreaterThanOrEqual,
                                                   toItem: self,
                                                   attribute: .Top,
                                                   multiplier: 1,
                                                   constant: insets.top)
            addConstraint(constraintTop)
            
            let constraintBottom = NSLayoutConstraint(item: self,
                                                      attribute: .Bottom,
                                                      relatedBy: .GreaterThanOrEqual,
                                                      toItem: subview,
                                                      attribute: .Bottom,
                                                      multiplier: 1,
                                                      constant: insets.bottom)
            addConstraint(constraintBottom)
        }
        return (centerXContraint, centerYContraint)
    }
    
    typealias SizeLayoutRelation = (width: NSLayoutRelation, height: NSLayoutRelation)
    func addSubviewCentered(
        subview: UIView?, usingSize
        size: CGSize,
        sizeRelation: SizeLayoutRelation = (width: .Equal, height: .Equal),
        offset: UIOffset = UIOffset(horizontal: 0.0, vertical: 0.0)) {
        
        guard let subview = subview where size != CGSize.zero else {
            return
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let centerX = NSLayoutConstraint(
            item: subview,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: offset.horizontal
        )
        
        let centerY = NSLayoutConstraint(
            item: subview,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: offset.vertical
        )
        
        let width = NSLayoutConstraint(
            item: subview,
            attribute: .Width,
            relatedBy: sizeRelation.width,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: size.width
        )
        
        let height = NSLayoutConstraint(
            item: subview,
            attribute: .Height,
            relatedBy: sizeRelation.height,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: size.height
        )
        
        addConstraints([width, height, centerX, centerY])
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    func addViewWithLayoutFormat(format: String, views: [String:UIView]) -> [NSLayoutConstraint]? {
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format,
                options: NSLayoutFormatOptions(),
                metrics: nil,
                views: views)
        self.addConstraints(constraints)

        return constraints
    }

    func constraintFor(item item: UIView, attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstAttribute == attribute && constraint.firstItem === item {
                return constraint
            }
            
            if constraint.secondAttribute == attribute && constraint.secondItem === item {
                return constraint
            }
        }
        
        return nil
    }
    
    func addSubviewWithInsets(subview: UIView?, insets: UIEdgeInsets) -> Void {
        if let view = subview {
            view.translatesAutoresizingMaskIntoConstraints = false
            let horizontalFormat: String = "H:|-(left)-[subview]-(right)-|"
            let verticalFormat: String = "V:|-(top)-[subview]-(bottom)-|"
            let viewsDict = ["subview": view]
            let metrics = [
                "left": insets.left,
                "right": insets.right,
                "top": insets.top,
                "bottom": insets.bottom
            ]
            self.addSubview(view)
            
            let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat(horizontalFormat, options: NSLayoutFormatOptions(), metrics: metrics, views: viewsDict)
            let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat(verticalFormat, options: NSLayoutFormatOptions(), metrics: metrics, views: viewsDict)
            
            self.addConstraints(constraintsH)
            self.addConstraints(constraintsV)
        }
    }
    
    func updateConstraintsWithInset(insets: UIEdgeInsets, immediately: Bool = false) {
        guard let superView = superview else {
            return
        }
        
        let attributes: [(attribute: NSLayoutAttribute, constant: CGFloat)] = [
            (.Top, insets.top),
            (.Left, insets.left),
            (.Leading, insets.left),
            (.Bottom, insets.bottom),
            (.Right, insets.right),
            (.Trailing, insets.right)
        ]
        
        for pair in attributes {
            if let constraint = superView.constraintFor(item: self, attribute: pair.attribute) {
                constraint.constant = pair.constant
            }
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        
        if immediately {
            layoutIfNeeded()
        }
    }
}