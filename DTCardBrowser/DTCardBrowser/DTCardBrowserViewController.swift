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
    lazy var backgroundImageView: UIImageView! = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    /// 显示卡片的视图
    var cardView = DTCardView(frame: CGRect.zero)

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
        
        if let w = cfg.coverAttributes.coverWidth, h = cfg.coverAttributes.coverHeight {
            cardView.coverView = DTCoverView(frame: CGRectMake(0, 0, w, h))
        } else {
            cardView.coverView = DTCoverView(frame: CGRectMake(0, 0, 300, 300))
        }
        
        if let image = cfg.coverAttributes.logoImage {
            cardView.coverView!.logoImageView.image = image
            cardView.coverView!.logoImageView.sizeToFit()
        } else {
            cardView.coverView!.logoImageView.image = UIImage(named: "")
            cardView.coverView!.logoImageView.sizeToFit()
        }
        
        cardView.frame = view.bounds
        view.addSubview(cardView)
    }

}
