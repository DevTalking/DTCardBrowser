//
//  CardView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/5/31.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCardView: UIView, UIGestureRecognizerDelegate {
    
    var coverView: DTCoverView? = nil {
        didSet {
            guard coverView != oldValue else {
                return
            }
            oldValue?.removeFromSuperview()
            
            if let cv = coverView {
                addSubview(cv)
//                cv.frame.origin.y = (self.frame.size.height - cv.frame.size.height) / 2
//                let verticalConstraint = NSLayoutConstraint(item: coverView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
//                let topConstraintConstant = (self.frame.size.height - coverView!.frame.size.height) / 2
//                let topConstraint = NSLayoutConstraint(item: coverView!, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: topConstraintConstant)
//                addConstraints([verticalConstraint, topConstraint])
            }
        }
    }
    
    var cards: [DTCard] = [] {
        didSet {
            updateAllCards()
            updateVisibleCards()
        }
    }
    
    var offset: CGFloat = 0 {
        didSet {
            bounds.origin.x = offset
            let originCenter = CGPoint(x: bounds.midX, y: bounds.midY)
            let destinationCenter = CGPoint(x: bounds.midX, y: coverView!.frame.size.height / 2)
//            if coverView!.center.y > destinationCenter.y {
//                coverView!.center = originCenter.toDestination(destinationCenter, scalar: offset / bounds.size.width / 0.2)
//            }
            coverView!.center = originCenter.toDestination(destinationCenter, scalar: offset / bounds.size.width / 0.2)
//            coverView!.center = destinationCenter
            updateVisibleCards()
        }
    }
    
    var visibleCards = Set<DTCard>()
    var panGesture = UIPanGestureRecognizer()
    let offsetRetio: CGFloat = 0.68
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(self.pan(_:)))
        panGesture.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAllCards() {
        for index in 0 ..< cards.count {
            let card = cards[index]
            card.cardCenter.x = bounds.midX + CGFloat(index + 1) * bounds.width * offsetRetio
            card.cardCenter.y = bounds.midY
            card.cardTransform = CGAffineTransformMakeScale(0.55, 0.55)
            card.cardSize = bounds.size
        }
    }
    
    func updateVisibleCards() {
        for card in cards {
            let isVisible = visibleCards.contains(card)
            let shouldVisible = card.cardFrame.intersects(bounds)
            if isVisible && !shouldVisible {
                hideCard(card)
            } else if !isVisible && shouldVisible {
                showCard(card)
            }
        }
    }
    
    func showCard(card: DTCard) {
        visibleCards.insert(card)
        updateViewForCard(card)
        addSubview(card)
        card.addSubview(card.viewController!.view)
        card.viewController!.view.frame = card.bounds
    }
    
    func hideCard(card: DTCard) {
        visibleCards.remove(card)
        card.removeFromSuperview()
    }
    
    func updateViewForCard(card: DTCard) {
        card.bounds = CGRect(origin: CGPoint.zero, size: card.cardSize)
        card.center = card.cardCenter
        card.transform = card.cardTransform
        card.layer.anchorPoint = card.cardAnchorPoint
    }
    
    func pan(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .Changed:
            offset = -recognizer.translationInView(self).x * offsetRetio
        default:
            break
        }
    }
    
}
