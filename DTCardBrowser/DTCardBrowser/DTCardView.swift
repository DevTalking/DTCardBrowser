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

            var coverViewTransformScalar =  min(offset / bounds.size.width / 0.5, 0.9)
            coverViewTransformScalar = max(coverViewTransformScalar, 0)
            coverView!.moveWithScalar(coverViewTransformScalar, andTransform: CGAffineTransformMakeScale(1 - coverViewTransformScalar * 0.3, 1 - coverViewTransformScalar * 0.3))
            
            updateVisibleCards()
//            var cardTransformScalar = min(0.55 + offset * 0.001, 0.65)
//            cardTransformScalar = max(cardTransformScalar, 0.55)
//            print(0.55 + offset * 0.001 / CGFloat(visibleCards.count))
//            let card = calculateCentermostCard()
//            card?.transform = CGAffineTransformMakeScale(cardTransformScalar, cardTransformScalar)
//            print(card!.frame.origin.x)
        }
    }
    
    var cardTransformScalar: CGFloat {
        set {
            newValue
        }
        get {
            self.cardTransformScalar += 0.01
            return min(self.cardTransformScalar, 0.65)
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
    
    func calculateCentermostCard() -> DTCard? {
        var closestDistance = CGFloat.max
        var closestCard: DTCard?
        for card in visibleCards {
            var distance: CGFloat = 0
            leftPaned() {
                distance = abs(card.frame.origin.x - self.bounds.midX)
            }
            rightPaned() {
                if self.visibleCards.count == 1 {
                    closestCard = nil
                    distance = closestDistance
                } else {
                    distance = abs(card.frame.origin.x + card.frame.size.width - self.bounds.midX)
                }
            }

            if distance < closestDistance {
                closestDistance = distance
                closestCard = card
            }
        }
        
        if let card = closestCard {
            bringSubviewToFront(card)
        }
        
        return closestCard
    }
    
    func leftPaned(codeBlock: () -> Void) {
        if offset > offsetWhenPanBegan {
            codeBlock()
        }
    }
    
    func rightPaned(codeBlock: () -> Void) {
        if offset < offsetWhenPanBegan {
            codeBlock()
        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .Began:
            offsetWhenPanBegan = offset
        case .Changed:
            offset = round(offsetWhenPanBegan - recognizer.translationInView(self).x * offsetRetio)
            break
        case .Ended, .Cancelled:
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .AllowUserInteraction, animations: {
                self.leftPaned() {
                    self.coverView!.moveWithScalar(0.9, andTransform: CGAffineTransformMakeScale(1 - 0.9 * 0.3, 1 - 0.9 * 0.3))
                }
                self.rightPaned() {
                    if self.visibleCards.count == 1 {
                        self.coverView!.moveWithScalar(0, andTransform: CGAffineTransformMakeScale(1, 1))
                    }
                }
                
                if let centermostCard = self.calculateCentermostCard() {
                    self.bounds.origin.x = centermostCard.frame.origin.x - (self.bounds.size.width - centermostCard.frame.width) / 2
                    centermostCard.transform = CGAffineTransformMakeScale(0.65, 0.65)
                } else {
                    self.bounds.origin.x = 0
                }
                self.coverView!.center.x = self.bounds.midX
            }, completion: nil)
            
            self.offset = self.bounds.origin.x
        default:
            break
        }
    }
    
}

extension CGPoint {
    
    func toDestination(destination: CGPoint, scalar: CGFloat) -> CGPoint {
        guard self != destination else {
            return destination
        }
        var newPoint = CGPoint.zero
        newPoint.x = x + scalar * (destination.x - x)
        newPoint.y = y + scalar * (destination.y - y)
        return newPoint
    }
    
}

extension UIView {
    
    func moveViewWithTransform(originCenterOfView originCenterOfView: CGPoint, destinationCenterOfView: CGPoint, moveScalar: CGFloat, transform: CGAffineTransform) {
        self.center = originCenterOfView.toDestination(destinationCenterOfView, scalar: moveScalar)
        self.transform = transform
    }
    
}
