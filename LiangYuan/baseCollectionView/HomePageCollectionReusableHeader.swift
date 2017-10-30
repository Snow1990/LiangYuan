//
//  HomePageCollectionReusableHeader.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
protocol SNHomePageHeaderDelegate: NSObjectProtocol {
    func snClickControl(headerView: HomePageCollectionReusableHeader, control: UIControl)

}
class HomePageCollectionReusableHeader: UICollectionReusableView {
    var section: Int?
    var label = UILabel()
    var moreLabel = UILabel()
    var bgControl = UIControl()
    weak var delegate: SNHomePageHeaderDelegate?
//    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 标题
        label.frame = CGRect(
            x: 110 * Constants.Scale,
            y: 22 * Constants.Scale,
            width: 500 * Constants.Scale,
            height: 36 * Constants.Scale)
        label.font = Constants.Font3
        label.textColor = Constants.MainColor
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        
        moreLabel.frame = CGRect(
            x: 600 * Constants.Scale,
            y: 22 * Constants.Scale,
            width: 100 * Constants.Scale,
            height: 36 * Constants.Scale)
        moreLabel.font = Constants.Font3
        moreLabel.textColor = Constants.MainColor
        moreLabel.text = "更多"
//        imageView.image = UIImage(named: "home_more")
//        imageView.backgroundColor = UIColor.redColor()
        self.addSubview(moreLabel)
        
        bgControl.frame = CGRect(
            x: 110 * Constants.Scale,
            y: 0 * Constants.Scale,
            width: 610 * Constants.Scale,
            height: 80 * Constants.Scale)
//        bgControl.backgroundColor = .blue
        bgControl.addTarget(self, action: #selector(clickControl(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(bgControl)
    }
    @objc func clickControl(sender: UIControl) {
        self.delegate?.snClickControl(headerView: self, control: sender)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func reuseIdentifier() -> String{
        return "HomePageCollectionReusableHeaderReuseIdentifier"
    }
    
}
