//
//  HomePageCollectionReusableFooter.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class HomePageCollectionReusableFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func reuseIdentifier() -> String{
        return "HomePageCollectionReusableFooterReuseIdentifier"
    }
}
