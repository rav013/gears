//
//  ViewController.swift
//  PossessionImprovements
//
//  Created by Rafal Szastok on 09/07/16.
//  Copyright © 2016 Szu Corpo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var v0: UIView!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    var circles: [PossessionCircleView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var possessionCircleView = PossessionCircleView(frame: CGRect.zero)
        possessionCircleView.possessionHome = 0.05
        circles.append(possessionCircleView)
        v0.addSubviewStretched(possessionCircleView)
        
        possessionCircleView = PossessionCircleView(frame: CGRect.zero)
        possessionCircleView.possessionHome = 0.45
        circles.append(possessionCircleView)
        v1.addSubviewStretched(possessionCircleView)
        
        possessionCircleView = PossessionCircleView(frame: CGRect.zero)
        possessionCircleView.possessionHome = 0.55
        circles.append(possessionCircleView)
        v2.addSubviewStretched(possessionCircleView)
        
        possessionCircleView = PossessionCircleView(frame: CGRect.zero)
        possessionCircleView.possessionHome = 0.85
        circles.append(possessionCircleView)
        v3.addSubviewStretched(possessionCircleView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circles.forEach({ (c) in
            c.setNeedsDisplay()
            c.setNeedsLayout()
        })

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.circles.forEach({ (c) in
                c.update(true)
            })
        }
    }
    
}

