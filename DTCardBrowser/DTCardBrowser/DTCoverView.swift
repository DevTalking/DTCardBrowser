//
//  CoverView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/1.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCoverView: UIStackView {

    /// Logo图片视图
    var logoImageView = UIImageView(frame: CGRect.zero) {
        didSet {
            guard logoImageView != oldValue else {
                return
            }
            oldValue.removeFromSuperview()
            logoImageView.sizeToFit()
            addArrangedSubview(logoImageView)
        }
    }
    
    /// Logo图片下的描述信息文本
    var descriptions: String? = nil {
        didSet {
            attributes[NSFontAttributeName] = UIFont.systemFontOfSize(descriptionFontSize, weight: UIFontWeightHeavy)
            attributes[NSForegroundColorAttributeName] = descriptionFontColor
            descriptionLabel.attributedText = NSAttributedString(string: descriptions ?? "DTBrowser by DevTalking", attributes: attributes)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .Center
            descriptionLabel.sizeToFit()
            addArrangedSubview(descriptionLabel)
        }
    }

    /// 显示描述信息的Label
    var descriptionLabel = UILabel(frame: CGRect.zero)
    /// 描述信息文本颜色
    var descriptionFontColor = UIColor.whiteColor()
    /// 描述信息文本大小
    var descriptionFontSize: CGFloat = 12.0
    /// 描述信息文本属性
    var attributes: [String: AnyObject] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .Vertical
        alignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更新DTCoverView的尺寸大小和位置。如果有描述，则高度等于Logo图片高度加上描述文本的高度，否则高度等于Logo图片的高度，宽度等于父视图的0.75倍，位置位于父视图的中心
    func config() {
        let stackViewWidth = superview!.bounds.size.width * 0.75
        if descriptions != nil {
            let descriptionLabelSize = (descriptionLabel.text! as NSString).boundingRectWithSize(CGSizeMake(stackViewWidth, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
            frame.size = CGSize(width: stackViewWidth, height: logoImageView.frame.height + descriptionLabelSize.height)
        } else {
            frame.size = CGSize(width: stackViewWidth, height: logoImageView.frame.height)
        }
        center = CGPoint(x: superview!.bounds.midX, y: superview!.bounds.midY)
    }
    
    /// 根据制定的起始位置和终止位置，以及移动比例移动视图，同时缩放视图
    /// - parameter scalar: 位置比例
    /// - parameter transform: 转换矩阵
    func moveWithScalar(scalar: CGFloat, andTransform transform: CGAffineTransform) {
        self.transform = transform
        let originCenter = CGPoint(x: superview!.bounds.midX, y: superview!.bounds.midY)
        let destinationCenter = CGPoint(x: superview!.bounds.midX, y: frame.size.height / 2)
        center = originCenter.toDestination(destinationCenter, scalar: scalar)
        descriptionLabel.alpha = 0.9 - scalar
    }
    
}
