//
//  DTCardBrowserViewController.swift
//  DTCardBrowser
//
//  Created by JaceFu on 16/5/30.
//  Copyright © 2016年 DevTalking. All rights reserved.
//

import UIKit

public class DTCardBrowserViewController: UIViewController {
    
    /// 背景图视图
    var backgroundImageView: UIImageView! = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    /// 显示卡片的视图
    var cardView = DTCardView(frame: CGRect.zero)
    /// viewController数组，即显示卡片内容的视图控制器
    var viewControllers: [UIViewController]?

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 配置卡片浏览控制器的方法，比如背景图片，Logo图片，卡片控制器，各种按钮等
    /// - parameter cfg: 配置项结构体
    public func dtCardBrowserConfig(configuration cfg: DTCardBrowserConfiguration) {
        if let image = cfg.backgroundImage {
            backgroundImageView.frame = view.bounds
            backgroundImageView.image = image
            view.addSubview(backgroundImageView)
        }
        
        cardView.frame = view.bounds
        view.addSubview(cardView)
        
        cardView.coverView = DTCoverView(frame: CGRect.zero)
        if let image = cfg.coverAttributes.logoImage {
            cardView.coverView!.logoImageView = UIImageView(image: image)
        } else {
            cardView.coverView!.logoImageView = UIImageView(image: UIImage(named: ""))
        }
        
        cardView.coverView!.descriptionFontSize = cfg.coverAttributes.descriptionFontSize == nil ? 12.0 : cfg.coverAttributes.descriptionFontSize!
        cardView.coverView!.descriptionFontColor = cfg.coverAttributes.descriptionFontColor == nil ? UIColor.whiteColor() : cfg.coverAttributes.descriptionFontColor!
        cardView.coverView!.descriptions = cfg.coverAttributes.description
        cardView.coverView!.config()
        
//        if let vcs = cfg.viewControllers {
//            cardView.cards = vcs.map {
//                addChildViewController($0)
//                $0.didMoveToParentViewController(self)
//                
//                let dtCard = DTCard(frame: CGRect.zero)
//                dtCard.viewController = $0
//                return dtCard
//            }
//        }
        if let vcs = cfg.cardAttributes {
            cardView.cards = vcs.map {
                addChildViewController($0.2)
                $0.2.didMoveToParentViewController(self)
                $0.0.cardViewController = $0.2
                $0.0.cardBackgourndView = $0.1
                return $0.0
            }
        }
    }

}
