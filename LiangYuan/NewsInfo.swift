//
//  NewsInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/10/18.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsInfo: NSObject {
    
    // 新闻id
    var newsCode: Int?
    // 新闻标题
    var newsTitle: String?
    // 图片地址
    var newsImgUrl: String?
    
    init(newsCode: Int) {
        self.newsCode = newsCode
    }
    init(newsJSON: JSON) {
        self.newsCode  = newsJSON["newsCode"].int
        self.newsTitle = newsJSON["newsTitle"].string
        self.newsImgUrl = newsJSON["newsImgUrl"].string
        
    }
}
