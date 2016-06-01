//
//  CoverView.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/6/1.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

class DTCoverView: UIView {

//    var logoImageView: UIImageView? = nil {
//        didSet {
//            guard logoImageView != oldValue else {
//                return
//            }
//            logoImageView?.removeFromSuperview()
//            
//            if let imageView = logoImageView {
//                imageView.sizeToFit()
//                addSubview(imageView)
//                
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                let hc = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
//                addConstraint(hc)
//            }
//        }
//    }
    lazy var logoImageView = UIImageView(frame: CGRect.zero)
    lazy var descriptionLabel = UILabel(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let hc = NSLayoutConstraint(item: logoImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        addConstraint(hc)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print("DTCoverView.layoutSubviews")
    }
    
}
