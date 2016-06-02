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
            if #available(iOS 8.2, *) {
                attributes[NSFontAttributeName] = UIFont.systemFontOfSize(descriptionFontSize, weight: UIFontWeightHeavy)
                attributes[NSForegroundColorAttributeName] = descriptionFontColor
                descriptionLabel.attributedText = NSAttributedString(string: descriptions ?? "", attributes: attributes)
                descriptionLabel.sizeToFit()
                addSubview(descriptionLabel)
                
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                let hc = NSLayoutConstraint(item: descriptionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: logoImageView, attribute: .CenterX, multiplier: 1, constant: 0)
                addConstraint(hc)
            } else {
                // Fallback on earlier versions
            }
        }
    }

    var descriptionLabel = UILabel(frame: CGRect.zero)
    var descriptionFontColor = UIColor.whiteColor()
    var descriptionFontSize: CGFloat = 12.0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("DTCoverView.layoutSubviews")
    }
    
}
