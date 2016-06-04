//
//  CardView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/5/31.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCardView: UIView {
    
    var coverView: DTCoverView? = nil {
        didSet {
            guard coverView != oldValue else {
                return
            }
            oldValue?.removeFromSuperview()
            
            if let cv = coverView {
                addSubview(cv)
                
                let verticalConstraint = NSLayoutConstraint(item: coverView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
                let topConstraintConstant = (self.frame.size.height - coverView!.frame.size.height) / 2
                let topConstraint = NSLayoutConstraint(item: coverView!, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: topConstraintConstant)
                addConstraints([verticalConstraint, topConstraint])
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
