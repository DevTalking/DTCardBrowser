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
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 配置卡片浏览控制器的方法，比如背景图片，Logo图片，卡片控制器，各种按钮等
    /// - parameter cfg: 配置项结构体
    public func dtCardBrowserConfig(configuration cfg: DTCardBrowserConfiguration) {
        backgroundImageView.frame = view.bounds
        backgroundImageView.image = cfg.backgroundImage
        view.addSubview(backgroundImageView)
        
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
        
        if let vcs = cfg.viewControllers {
            cardView.cards = vcs.map {
                addChildViewController($0)
                $0.didMoveToParentViewController(self)
                let dtCard = DTCard(frame: CGRect.zero)
                dtCard.viewController = $0
                return dtCard
            }
        }
    }

}
