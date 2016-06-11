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
            coverView!.center.x = bounds.midX
            let originCenter = CGPoint(x: bounds.midX, y: bounds.midY)
            let destinationCenter = CGPoint(x: bounds.midX, y: coverView!.frame.size.height / 2)
            var scalar =  min(offset / bounds.size.width / 0.5, 0.9)
            scalar = max(scalar, 0)
            coverView!.center.y = (originCenter.toDestination(destinationCenter, scalar: scalar)).y
            coverView!.transform = CGAffineTransformMakeScale(1 - scalar * 0.3, 1 - scalar * 0.3)
            coverView!.descriptionLabel.alpha = 0.9 - scalar
            updateVisibleCards()
        }
    }
    
    var offsetWhenPanBegan: CGFloat = 0
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
        case .Began:
            offsetWhenPanBegan = offset
        case .Changed:
            offset = offsetWhenPanBegan - recognizer.translationInView(self).x * offsetRetio
            break
        case .Ended, .Cancelled:
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .AllowUserInteraction, animations: {
                let originCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                let destinationCenter = CGPoint(x: self.bounds.midX, y: self.coverView!.frame.size.height / 2)
                self.coverView!.center.y = (originCenter.toDestination(destinationCenter, scalar: 0.9)).y
                self.coverView!.transform = CGAffineTransformMakeScale(1 - 0.9 * 0.3, 1 - 0.9 * 0.3)
            }, completion: nil)
        default:
            break
        }
    }
    
}
