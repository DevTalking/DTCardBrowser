//
//  CoverView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/1.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCoverView: UIView {

    var logoImageView = UIImageView(frame: CGRect.zero) {
        didSet {
            guard logoImageView != oldValue else {
                return
            }
            logoImageView.removeFromSuperview()
            
            logoImageView.sizeToFit()
            addSubview(logoImageView)
            
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            let hc = NSLayoutConstraint(item: logoImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
            addConstraint(hc)
        }
    }
    
    var descriptions: String? = nil {
        didSet {
            var attributes: [String: AnyObject] = [:]
            attributes[NSFontAttributeName] = UIFont.systemFontOfSize(descriptionFontSize, weight: UIFontWeightHeavy)
            attributes[NSForegroundColorAttributeName] = descriptionFontColor
            descriptionLabel.attributedText = NSAttributedString(string: descriptions ?? "DTBrowser by DevTalking", attributes: attributes)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            addSubview(descriptionLabel)
            
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let verticalConstraint = NSLayoutConstraint(item: descriptionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: logoImageView, attribute: .CenterX, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: descriptionLabel, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Width, multiplier: 0.9, constant: 0)
            let topConstraint = NSLayoutConstraint(item: descriptionLabel, attribute: .Top, relatedBy: .Equal, toItem: logoImageView, attribute: .Bottom, multiplier: 1, constant: 5)
            addConstraints([verticalConstraint, widthConstraint, topConstraint])
            layoutIfNeeded()
            
            let bottomConstraintConstant = (self.frame.size.height - (logoImageView.frame.size.height + descriptionLabel.frame.size.height + 5)) / 2
            let bottomConstraint = NSLayoutConstraint(item: logoImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: bottomConstraintConstant)
            addConstraint(bottomConstraint)
        }
    }

    var descriptionLabel = UILabel(frame: CGRect.zero)
    var descriptionFontColor = UIColor.whiteColor()
    var descriptionFontSize: CGFloat = 12.0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: frame.size.width)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: frame.size.height)
        addConstraints([widthConstraint, heightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("DTCoverView.layoutSubviews")
    }
    
}
