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
    
    var cards: [DTCard] = [] {
        didSet {
            updateAllCards()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAllCards() {
        for index in 0 ..< cards.count {
            let card = cards[index]
            addSubview(card)
            card.frame.size = bounds.size
            card.center.y = bounds.midY
            card.center.x = bounds.midX + CGFloat(index + 1) * bounds.width * 0.68
            let scale = CGAffineTransformMakeScale(0.6, 0.6)
            card.transform = scale
            card.backgroundColor = UIColor.cyanColor()
            card.addSubview(card.viewController!.view)
//            card.viewController!.view.frame.origin = card.bounds.origin
//            card.viewController!.view.frame.size = card.frame.size
            card.viewController!.view.frame = card.bounds
        }
    }
    
}
