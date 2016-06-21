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
            // 卡片数组赋值完成之后更新卡片
            updateAllCards()
            updateVisibleCards()
        }
    }
    
    /// DTCardView偏移量
    var offset: CGFloat = 0 {
        didSet {
            // 当offset赋值完成后，将DTCardView移动至该位置。
            bounds.origin.x = offset
            
            // 在offset的基础上计算coverView的移动比例，即在给定的一段距离中，移动到哪个位置，该比例在0至0.9之间
            var coverViewMoveScalar =  min(offset / bounds.size.width / 0.7, 0.9)
            coverViewMoveScalar = max(coverViewMoveScalar, 0)
            // 在coverView移动到某个比例位置的过程中，尺寸也按照一定比例进行缩放
            coverView!.moveWithScalar(coverViewMoveScalar, andTransform: CGAffineTransformMakeScale(1 - coverViewMoveScalar * 0.3, 1 - coverViewMoveScalar * 0.3))
            updateVisibleCards()
        }
    }
    /// 新一次滑动时DTCardView的X坐标偏移量，也就是上一次滑动完成之后的偏移量
    var offsetXWhenPanBegan: CGFloat = 0
    /// 新一次滑动时DTCardView的Y坐标偏移量，也就是上一次滑动完成之后的偏移量
    var offsetYWhenPanBegan: CGFloat = 0
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
    /// 计算滑动方向时的最小有效滑动量（x坐标或y坐标）
    var minimumPanTranslation: CGFloat = 10
    
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

    /// 更新cards数组中所有卡片的属性：center、size、transform。该方法更新的不是卡片真正视图的这些属性，而是DTCard中代表视图属性的存储属性。因为在计算这些属性时，卡片视图并没有加入到父视图中。所以在这里先将视图属性进行存储，用于以后更新真正的视图属性
    private func updateAllCards() {
        for index in 0 ..< cards.count {
            let card = cards[index]
            // 通过center属性确定卡片的位置：center.y坐标与父视图一致；center.x坐标，第一个卡片偏移父视图（DTCardView）一半宽度，然后再偏离卡片宽度的offsetretio倍，之后卡片的偏移位置在偏离父视图（DTCardView）一半宽度的基础上再加offsetRetio倍卡片宽度的数组下标倍数
            card.cardCenter.x = bounds.midX + CGFloat(index + 1) * bounds.width * offsetRetio
            card.cardCenter.y = bounds.midY
            // 卡片的缩放比例
            card.cardTransform = CGAffineTransformMakeScale(minCardTransformScalar, minCardTransformScalar)
//            card.cardSize = bounds.size
            card.cardSize = CGSize(width: bounds.size.width, height: bounds.size.height * 0.75)
        }
    }
    
    /// 判断卡片的显示状态，并依据判断结果显示或移除卡片
    private func updateVisibleCards() {
        for card in cards {
            // 判断卡片是否在visibleCards数组中，以此判断该卡片是否正在显示中
            let isVisible = visibleCards.contains(card)
            // 判断该卡片是否与父视图（DTCardView）有交集，以此判断该卡片是否应该被显示。这里要注意的是card.cardFrame并不是卡片视图的真正属性，而是之前计算出的，但可以代表之后卡片视图显示的位置
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
    private func showCard(card: DTCard) {
        visibleCards.insert(card)
        updateViewForCard(card)
        addSubview(card.cardBackgourndView!)
        addSubview(card)
        
        // 当卡片视图显示viewController的内容
//        card.addSubview(card.viewController!.view)
//        card.cardViewController!.view.frame = card.bounds
    }
    
    /// 移除卡片，即将DTCard从DTCardView中移除
    /// - parameter card: 卡片视图
    private func removeCard(card: DTCard) {
        visibleCards.remove(card)
        card.removeFromSuperview()
    }
    
    /// 更新卡片视图真正的属性
    /// - parameter card: 卡片视图
    private func updateViewForCard(card: DTCard) {
        card.bounds = CGRect(origin: CGPoint.zero, size: card.cardSize)
        card.center = card.cardCenter
        card.transform = card.cardTransform
        card.layer.anchorPoint = card.cardAnchorPoint
        card.backgroundColor = UIColor.whiteColor()
        card.layer.cornerRadius = card.cardCornerRatius
        card.layer.shadowOffset = CGSize(width: 0, height: 10)
        card.layer.shadowColor = UIColor.blackColor().CGColor
        card.layer.shadowRadius = 5
        card.layer.shadowOpacity = 0.2
        card.cardBackgourndView!.frame.origin = CGPoint(x: card.frame.origin.x + 5, y: card.frame.origin.y + 5)
        card.cardBackgourndView!.frame.size = CGSize(width: card.frame.width - 10, height: card.frame.height - 10)
        card.cardBackgourndView!.layer.cornerRadius = 5
    }
    
    /// 计算当前显示在中间卡片的前一个卡片
    private func calculatePreviousOfCenterCard() -> DTCard? {
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
    
    /// 计算当前显示在中间卡片的后一个卡片
    private func calculateNextOfCenterCard() -> DTCard? {
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
    
    /// 计算当前显示在中间的卡片
    private func calculateCenterCard() {
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
    
    /// 手势向左滑动时需要处理逻辑的方法
    /// - parameter codeBlock: 向左滑动时需要执行的闭包
    private func leftPaned(codeBlock: () -> Void) {
        if offset > offsetXWhenPanBegan {
            codeBlock()
        }
    }
    
    /// 手势向右滑动时需要处理逻辑的方法
    /// - parameter codeBlock: 向右滑动时需要执行的闭包
    private func rightPaned(codeBlock: () -> Void) {
        if offset < offsetXWhenPanBegan {
            codeBlock()
        }
    }
    
    /// 手势水平滑动
    /// - parameter translation: 滑动距离
    private func horizontalPaned(translation: CGPoint) -> Bool {
        return determinePanMoveDirection(translation) == .PanMoveLeft || determinePanMoveDirection(translation) == .PanMoveRight
    }
    
    /// 手势垂直滑动
    /// - parameter translation: 滑动距离
    private func verticalPaned(translation: CGPoint) -> Bool {
        return determinePanMoveDirection(translation) == .PanMoveUp || determinePanMoveDirection(translation) == .PanMoveDown
    }
    
    /// 在中央卡片中上下滑动
    /// - parameter translation: 手指滑动距离
    /// - parameter location: 手指在卡片中的位置
    /// - parameter handler: 处理闭包
    private func isVerticalPanedInCenterCard(translation: CGPoint, location: CGPoint) -> Bool {
        if let card = centerCard {
            return verticalPaned(translation) && card.frame.contains(location)
        } else {
            return false
        }
    }
    
    /// 计算滑动方向
    /// - parameter translation: 滑动距离
    private func determinePanMoveDirection(translation: CGPoint) -> PanMoveDirection {
        // 滑动距离大于最小有效距离视为触发滑动
        if fabs(translation.x) > minimumPanTranslation {
            var panHorizontal = false
            
            if translation.y == 0 {
                panHorizontal = true
            } else {
                // x坐标距离与y坐标距离之比大于4视为水平滑动
                panHorizontal = fabs(translation.x / translation.y) > 4
            }
            
            if panHorizontal {
                if translation.x > 0 {
                    return .PanMoveRight
                } else {
                    return .PanMoveLeft
                }
            }
        } else if fabs(translation.y) > minimumPanTranslation {
            var panVertical = false
            
            if translation.x == 0 {
                panVertical = true
            } else {
                // y坐标距离与x坐标距离之比大于4视为水平滑动
                panVertical = fabs(translation.y / translation.x) > 4
            }
            
            if panVertical {
                if translation.y > 0 {
                    return .PanMoveDown
                } else {
                    return .PanMoveUp
                }
            }
        }
        return .PanNone
    }
    
    /// 进行滑动手势时触发的方法
    /// - parameter recognizer: 滑动手势
    func pan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self)
        let location = recognizer.locationInView(self)
        switch recognizer.state {
        case .Began:
            // 记录上次滑动完成后父视图（DTCardView）的x坐标位置
            offsetXWhenPanBegan = self.bounds.origin.x
        case .Changed:
            if horizontalPaned(translation) {
                // 计算偏移量：滑动开始时DTCardView的起始位置减去offsetRetio倍的手指滑动到的新位置，四舍五入取到一个滑动的距离
                offset = round(offsetXWhenPanBegan - translation.x * offsetRetio)
                
                // 对于在显示状态的每个卡片视图，计算出在移动时它们的中点x坐标与父视图（DTCardView）中点x坐标的距离，然后求出该距离占父视图（DTCardView）宽度的比例，以此比例计算中滑动过程中卡片视图的缩放比例，即卡片与父视图的距离越小，缩放比例越大，反之缩放比例越小
                for card in visibleCards {
                    var distance = abs(card.center.x - bounds.midX)
                    distance = min(distance, bounds.width * 1.4) / bounds.width * 1.4
                    card.transformScalar = maxCardTransformScalar - ((maxCardTransformScalar - minCardTransformScalar) * distance)
                }
            }
            break
        case .Ended, .Cancelled:
            // 如果在卡片中上下滑动，则不会移动卡片
            if isVerticalPanedInCenterCard(translation, location: location) {
                UIView.animateWithDuration(0.3) {
                    self.centerCard!.frame.origin.y -= 40
                    self.centerCard!.cardBackgourndView!.frame.size.width = self.centerCard!.frame.width + 30
                    self.centerCard!.cardBackgourndView!.frame.size.height = self.centerCard!.frame.height
                    self.centerCard!.cardBackgourndView!.frame.origin.x = self.centerCard!.frame.origin.x - 15
                }
            } else {
                // 当滑动结束，也就是手指离开屏幕后，通过UIView的弹簧动画完成卡片的归位，其中包括左右移动滑动一个卡片时封面视图的移动
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .AllowUserInteraction, animations: {
                    if let centerCard = self.centerCard {
                        // 中间有显示卡片的情况下，左滑结束时，中间卡片缩小，它的前一个卡片缩小，后一个卡片放大，同时父视图（DTCardView）移动到后一个卡片的中心位置。如果没有后一个卡片，即当前在中间的卡片为最后一个卡片时，只将父视图移动到该卡片的中心位置，该卡片的缩放比例保持为最大比例
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
                        
                        // 中间有显示卡片的情况下，右滑结束时，中间卡片缩小，它的前一个卡片放大，后一个卡片缩小，同时父视图（DTCardView）移动到前一个卡片的中心位置。如果没有前一个卡片，即当前显示在中间的卡片为第一个卡片时，只将父视图归位到初始位置，该卡片的缩放比例保持为最小比例，同时封面视图向下移动到父视图中心位置，高宽比例增大
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
                            
                            if self.calculatePreviousOfCenterCard() == nil {
                                self.coverView!.moveWithScalar(0, andTransform: CGAffineTransformMakeScale(1, 1))
                            }
                        }
                    } else {
                        // 中间没有卡片显示的情况下，左滑结束时，将唯一处于显示状态的卡片比例放大，同时将父视图（DTCardView）移动至该卡片的中心位置。同时封面视图向上移动，高宽比例缩小
                        self.leftPaned() {
                            for card in self.visibleCards {
                                self.bounds.origin.x = card.frame.origin.x - (self.bounds.size.width - card.frame.width) / 2
                                card.transformScalar = self.maxCardTransformScalar
                            }
                            self.coverView!.moveWithScalar(0.9, andTransform: CGAffineTransformMakeScale(1 - 0.9 * 0.3, 1 - 0.9 * 0.3))
                        }
                        // 中间没有卡片显示的情况下，右滑结束时，将父视图归位到初始位置
                        self.rightPaned() {
                            self.bounds.origin.x = 0
                        }
                    }
                    
                    // 封面视图的中心x坐标始终与父视图的中心x坐标保持一致
                    self.coverView!.center.x = self.bounds.midX
                    }, completion: nil)
                
                // 一次滑动结束后计算出新的处于中间的卡片视图，然后更新出新的要显示的卡片视图
                calculateCenterCard()
                updateVisibleCards()
            }
        default:
            break
        }
    }
    
}

extension CGPoint {
    
    /// 根据给定的比例，计算出给定的一段距离中的位置
    /// - parameter destination: 目的位置
    /// - parameter scalar: 这段距离中的某个位置，比如这段距离的三分之一，五分之一等
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

enum PanMoveDirection {
    case PanMoveUp, PanMoveDown, PanMoveLeft, PanMoveRight, PanNone
}
