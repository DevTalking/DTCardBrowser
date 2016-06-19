//
//  DTCard.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/4.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

public class DTCard: UIView {
    
    var cardFrame: CGRect {
        var f = CGRect.zero
        f.size = cardSize
        f = CGRectApplyAffineTransform(f, cardTransform)
        f.origin.x = cardCenter.x - f.size.width * cardAnchorPoint.x
        f.origin.y = cardCenter.y - f.size.height * cardAnchorPoint.y
        return f
    }

    var transformScalar: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransformMakeScale(transformScalar, transformScalar)
        }
    }
    
    var cardCenter = CGPoint.zero
    var cardSize = CGSize.zero
    var cardAnchorPoint = CGPoint(x: 0.5, y: 0.5)
    var cardTransform = CGAffineTransformIdentity
    var cardCornerRatius: CGFloat = 5.0
    var cardBackgourndView: DTCardBackground?
    let minCardTransformScalar: CGFloat = 0.5
    let maxCardTransformScalar: CGFloat = 0.65
    var cardViewController: UIViewController?
//    /// 拖动手势
//    var panGesture = UIPanGestureRecognizer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        transformScalar = minCardTransformScalar
        
//        addGestureRecognizer(panGesture)
//        panGesture.addTarget(self, action: #selector(self.pan(_:)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func pan(recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case .Began:
//            print("began")
//        case .Changed:
//            print("changed")
//        case .Ended, .Cancelled:
//            print("end")
//        default:
//            break
//        }
//    }
    
}
