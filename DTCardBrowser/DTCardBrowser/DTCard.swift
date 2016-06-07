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
        f.origin.x = cardAnchorPoint.x * cardCenter.x
        f.origin.y = cardAnchorPoint.y * cardCenter.y
        f = CGRectApplyAffineTransform(f, cardTransform)
        return f
    }

    var cardCenter = CGPoint.zero
    var cardSize = CGSize.zero
    var cardAnchorPoint = CGPoint(x: 0.5, y: 0.5)
    var cardTransform = CGAffineTransformIdentity
    var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
