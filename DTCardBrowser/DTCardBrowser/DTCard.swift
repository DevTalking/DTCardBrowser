//
//  DTCard.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/4.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCard: UIView {

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
