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
        }
    }
    
    var offsetWhenPanBegan: CGFloat = 0
    var visibleCards = Set<DTCard>()
    var panGesture = UIPanGestureRecognizer()
    let offsetRetio: CGFloat = 0.68
    let minCardTransformScalar: CGFloat = 0.5
    let maxCardTransformScalar: CGFloat = 0.65
    var centerCard: DTCard?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(self.pan(_:)))
        panGesture.delegate = self
        calculateMaxTransformCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAllCards() {
        for index in 0 ..< cards.count {
            let card = cards[index]
            card.cardCenter.x = bounds.midX + CGFloat(index + 1) * bounds.width * offsetRetio
            card.cardCenter.y = bounds.midY
            card.cardTransform = CGAffineTransformMakeScale(minCardTransformScalar, minCardTransformScalar)
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
    
    func calculatePreviousOfCenterCard() -> DTCard? {
        guard let centerCard = centerCard else {
            return nil
        }
        for card in visibleCards {
            if card.frame.origin.x < centerCard.frame.origin.x {
                return card
            }
        }
        return nil
    }
    
    func calculateNextOfCenterCard() -> DTCard? {
        guard let centerCard = centerCard else {
            return nil
        }
        for card in visibleCards {
            if card.frame.origin.x > centerCard.frame.origin.x {
                return card
            }
        }
        return nil
    }
    
    func calculateMaxTransformCard() {
        var maxTransformScalar = minCardTransformScalar
        var maxTransformCard: DTCard?
        for card in visibleCards {
            if card.transformScalar > maxTransformScalar {
                maxTransformScalar = card.transformScalar
                maxTransformCard = card
            }
        }
        centerCard = maxTransformCard
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
            
            for card in visibleCards {
                var distance = abs(card.center.x - bounds.midX)
                distance = min(distance, bounds.width * 1.4) / bounds.width * 1.4
                card.transformScalar = 0.65 - (0.15 * distance)
            }
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
                
                if let centerCard = self.centerCard {
                    self.leftPaned() {
                        if let previousOfCenterCard = self.calculatePreviousOfCenterCard() {
                            previousOfCenterCard.transformScalar = self.minCardTransformScalar
                        }
                        
                        if let nextOfCenterCard = self.calculateNextOfCenterCard() {
                            self.bounds.origin.x = nextOfCenterCard.frame.origin.x - (self.bounds.size.width - nextOfCenterCard.frame.width) / 2
                            nextOfCenterCard.transformScalar = self.maxCardTransformScalar
                            centerCard.transformScalar = self.minCardTransformScalar
                        } else {
                            self.bounds.origin.x = centerCard.frame.origin.x - (self.bounds.size.width - centerCard.frame.width) / 2
                            centerCard.transformScalar = self.maxCardTransformScalar
                        }
                        
                        
                    }
                    self.rightPaned() {
                        if let previousOfCenterCard = self.calculatePreviousOfCenterCard() {
                            self.bounds.origin.x = previousOfCenterCard.frame.origin.x - (self.bounds.size.width - previousOfCenterCard.frame.width) / 2
                            previousOfCenterCard.transformScalar = self.maxCardTransformScalar
                            centerCard.transformScalar = self.minCardTransformScalar
                        } else {
                            self.bounds.origin.x = 0
                            centerCard.transformScalar = self.minCardTransformScalar
                        }
                        
                        if let nextOfCenterCard = self.calculateNextOfCenterCard() {
                            nextOfCenterCard.transformScalar = self.minCardTransformScalar
                        }                        
                    }
                } else {
                    self.leftPaned() {
                        for card in self.visibleCards {
                            self.bounds.origin.x = card.frame.origin.x - (self.bounds.size.width - card.frame.width) / 2
                            card.transformScalar = self.maxCardTransformScalar
                        }
                    }
                    self.rightPaned() {
                        self.bounds.origin.x = 0
                    }
                }
                
                self.coverView!.center.x = self.bounds.midX
            }, completion: nil)
            calculateMaxTransformCard()
            offset = self.bounds.origin.x
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
