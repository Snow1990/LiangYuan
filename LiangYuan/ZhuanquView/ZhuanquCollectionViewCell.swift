//
//  ZhuanquCollectionViewCell.swift
//  LiangYuan
//
//  Created by SN on 2017/11/22.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class ZhuanquCollectionViewCell: UICollectionViewCell {
    
    // 课程简介
    var title = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        initCell()
    }
    class func reuseIdentifier() -> String{
        return "ZhuanquCollectionViewCellReuseIdentifier"
    }
    class func getSize() -> CGSize {
        return CGSize(
            width: 340 * Constants.Scale,
            height: 80 * Constants.Scale)
    }
    func initCell() {
        
        
        //课程名称
        title.backgroundColor = UIColor.clear
        title.text = "标题示例文字"
        title.font = Constants.Font4
        title.textAlignment = NSTextAlignment.center
        title.frame = CGRect(
            x: 20 * Constants.Scale,
            y: 20 * Constants.Scale,
            width: 300 * Constants.Scale,
            height: 40 * Constants.Scale)
        self.addSubview(title)
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
    }
}
