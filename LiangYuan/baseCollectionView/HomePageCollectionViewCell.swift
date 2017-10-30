//
//  HomePageCollectionViewCell.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {
    // 点击次数
    var clickCountNum: Int = 0 {
        didSet{
            clickCount.text = "点击：\(clickCountNum)"
        }
    }
    // 课程图片
    var imageView = UIImageView()
    // 课程简介
    var title = UILabel()
    // 多少人点击
    var clickCount = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        initCell()
    }
    class func reuseIdentifier() -> String{
        return "HomePageCollectionViewCellReuseIdentifier"
    }
    class func getSize() -> CGSize {
        return CGSize(
            width: 342 * Constants.Scale,
            height: 304 * Constants.Scale)
    }
    func initCell() {
        //课程图片
        imageView.backgroundColor = UIColor.brown
        imageView.isOpaque = false
        imageView.frame = CGRect(x: 0, y: 0, width: 342 * Constants.Scale, height: 200 * Constants.Scale)
        self.addSubview(imageView)
        
        
        //课程名称
        title.backgroundColor = UIColor.clear
        title.text = "标题示例文字"
        title.font = Constants.Font1
        title.frame = CGRect(
            x: 14 * Constants.Scale,
            y: 213 * Constants.Scale,
            width: 310 * Constants.Scale,
            height: 28 * Constants.Scale)
        self.addSubview(title)
        
        //课程点击次数
        clickCountNum = 12334
        clickCount.backgroundColor = UIColor.clear
        clickCount.textColor = UIColor.gray
        clickCount.font = Constants.Font1
        clickCount.baselineAdjustment = UIBaselineAdjustment.alignCenters
        clickCount.frame = CGRect(
            x: 14 * Constants.Scale,
            y: 254 * Constants.Scale,
            width: 168 * Constants.Scale,
            height: 24 * Constants.Scale)
        self.addSubview(clickCount)
    }
}
