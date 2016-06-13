//
//  CoverView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/1.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCoverView: UIStackView {

    var logoImageView = UIImageView(frame: CGRect.zero) {
        didSet {
            guard logoImageView != oldValue else {
                return
            }
            oldValue.removeFromSuperview()
            logoImageView.sizeToFit()
        }
    }
    
    var descriptions: String? = nil {
        didSet {
            var attributes: [String: AnyObject] = [:]
            attributes[NSFontAttributeName] = UIFont.systemFontOfSize(descriptionFontSize, weight: UIFontWeightHeavy)
            attributes[NSForegroundColorAttributeName] = descriptionFontColor
            descriptionLabel.attributedText = NSAttributedString(string: descriptions ?? "DTBrowser by DevTalking", attributes: attributes)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .Center
            descriptionLabel.sizeToFit()
            
            addArrangedSubview(logoImageView)
            addArrangedSubview(descriptionLabel)
            let stackViewWidth = superview!.bounds.size.width * 0.75
            let descriptionLabelSize = (descriptionLabel.text! as NSString).boundingRectWithSize(CGSizeMake(stackViewWidth, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
            frame.size = CGSize(width: stackViewWidth, height: logoImageView.frame.height + descriptionLabelSize.height)
            center = CGPoint(x: superview!.bounds.midX, y: superview!.bounds.midY)
        }
    }

    var descriptionLabel = UILabel(frame: CGRect.zero)
    var descriptionFontColor = UIColor.whiteColor()
    var descriptionFontSize: CGFloat = 12.0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .Vertical
        alignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveWithScalar(scalar: CGFloat, andTransform transform: CGAffineTransform) {
        let originCenter = CGPoint(x: superview!.bounds.midX, y: superview!.bounds.midY)
        let destinationCenter = CGPoint(x: superview!.bounds.midX, y: frame.size.height / 2)
        moveViewWithTransform(originCenterOfView: originCenter, destinationCenterOfView: destinationCenter, moveScalar: scalar, transform: transform)
        descriptionLabel.alpha = 0.9 - scalar
    }
    
}
