//
//  DTCard.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/4.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCard: UIView {
    
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
    let minCardTransformScalar: CGFloat = 0.5
    let maxCardTransformScalar: CGFloat = 0.65
    var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        transformScalar = minCardTransformScalar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
