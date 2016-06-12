//
//  DTCardBrowserConfiguration.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/5/31.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

public struct DTCardBrowserConfiguration {

    public var backgroundImage: UIImage?
    public var coverAttributes: CoverAttributes
    public var viewControllers: [UIViewController]?
    
    public init() {
        coverAttributes = CoverAttributes()
    }
    
}

public struct CoverAttributes {
    
    public var logoImage: UIImage?
    public var description: String?
    public var descriptionFontSize: CGFloat?
    public var descriptionFontColor: UIColor?
    
}
