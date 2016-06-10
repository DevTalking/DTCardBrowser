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
    
    public var coverWidth: CGFloat?
    public var coverHeight: CGFloat?
    public var logoImage: UIImage?
    public var description: String?
    public var descriptionFontSize: CGFloat?
    public var descriptionFontColor: UIColor?
    
}

extension CGPoint {
    
    func toDestination(destination: CGPoint, scalar: CGFloat) -> CGPoint {
        guard self != destination else {
            return destination
        }
        var newPoint = CGPoint.zero
        newPoint.x = x + scalar * (destination.x - x)
        newPoint.y = y + scalar * (destination.y - y)
//        x += scalar * (destination.x - x)
//        y += scalar * (destination.y - y)
        return newPoint
    }
    
}