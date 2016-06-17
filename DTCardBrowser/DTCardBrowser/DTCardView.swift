//
//  CardView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/5/31.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCardView: UIView, UIGestureRecognizerDelegate {
    
    /// Logo和描述的视图，即封面视图
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
    
    /// 卡片数组
    var cards: [DTCard] = [] {
        didSet {
            updateAllCards()
            updateVisibleCards()
        }
    }
    
    /// DTCardView偏移量
    var offset: CGFloat = 0 {
        didSet {
            // 当offset赋值完成后，将DTCardView移动至该位置。
            bounds.origin.x = offset
            
            // 在offset的基础上计算coverView的移动比例，即在给定的一段距离中，移动到哪个位置，该比例在0至0.9之间。
            var coverViewMoveScalar =  min(offset / bounds.size.width / 0.7, 0.9)
            coverViewMoveScalar = max(coverViewMoveScalar, 0)
            // 在coverView移动到某个比例位置的过程中，尺寸也按照一定比例进行缩放。
            coverView!.moveWithScalar(coverViewMoveScalar, andTransform: CGAffineTransformMakeScale(1 - coverViewMoveScalar * 0.3, 1 - coverViewMoveScalar * 0.3))
            
            updateVisibleCards()
        }
    }
    /// 拖动时的偏移量
    var offsetWhenPanBegan: CGFloat = 0
    /// 可视的卡片集合
    var visibleCards = Set<DTCard>()
    /// 拖动手势
    var panGesture = UIPanGestureRecognizer()
    /// 偏移率
    let offsetRetio: CGFloat = 0.68
    /// 卡片的最小缩放比例
    let minCardTransformScalar: CGFloat = 0.5
    /// 卡片的最大缩放比例
    let maxCardTransformScalar: CGFloat = 0.65
    /// 处于视图中间的卡片
    var centerCard: DTCard?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(self.pan(_:)))
        panGesture.delegate = self
        calculateCenterCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 更新cards数组中所有卡片的属性：center、size、transform。该方法更新的不是卡片真正视图的这些属性，而是DTCard中代表视图属性的存储属性。因为在计算这些属性时，卡片视图并没有加入到父视图中。所以在这里先将视图属性进行存储，用于以后更新真正的视图属性。
    func updateAllCards() {
        for index in 0 ..< cards.count {
            let card = cards[index]
            // 通过center属性确定卡片的位置：center.y坐标与父视图一致；center.x坐标，第一个卡片偏移父视图（DTCardView）一半宽度，然后再偏离卡片宽度的offsetretio倍，之后卡片的偏移位置在偏离父视图（DTCardView）一半宽度的基础上再加offsetRetio倍卡片宽度的数组下标倍数。
            card.cardCenter.x = bounds.midX + CGFloat(index + 1) * bounds.width * offsetRetio
            card.cardCenter.y = bounds.midY
            // 卡片的缩放比例
            card.cardTransform = CGAffineTransformMakeScale(minCardTransformScalar, minCardTransformScalar)
            card.cardSize = bounds.size
        }
    }
    
    /// 判断卡片的显示状态，并依据判断结果显示或移除卡片。
    func updateVisibleCards() {
        for card in cards {
            // 判断卡片是否在visibleCards数组中，以此判断该卡片是否正在显示中。
            let isVisible = visibleCards.contains(card)
            // 判断该卡片是否与父视图（DTCardView）有交集，以此判断该卡片是否应该被显示。这里要注意的是card.cardFrame并不是卡片视图的真正属性，而是之前计算出的，但可以代表之后卡片视图显示的位置。
            let shouldVisible = card.cardFrame.intersects(bounds)
            if isVisible && !shouldVisible {
                removeCard(card)
            } else if !isVisible && shouldVisible {
                showCard(card)
            }
        }
    }
    
    /// 显示卡片，即将DTCard作为子视图添加至DTCardView中。
    /// - parameter card: 卡片视图
    func showCard(card: DTCard) {
        visibleCards.insert(card)
        updateViewForCard(card)
        addSubview(card)
        // 当卡片视图显示viewController的内容
        card.addSubview(card.viewController!.view)
        card.viewController!.view.frame = card.bounds
    }
    
    /// 移除卡片，即将DTCard从DTCardView中移除。
    /// - parameter card: 卡片视图
    func removeCard(card: DTCard) {
        visibleCards.remove(card)
        card.removeFromSuperview()
    }
    
    func updateViewForCard(card: DTCard) {
        card.bounds = CGRect(origin: CGPoint.zero, size: card.cardSize)
        card.center = card.cardCenter
        card.transform = card.cardTransform
        card.layer.anchorPoint = card.cardAnchorPoint
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
    
    func calculateCenterCard() {
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
                    print(self.calculateNextOfCenterCard())
                    if self.calculatePreviousOfCenterCard() == nil {
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
            calculateCenterCard()
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
