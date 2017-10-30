//
//  ChapterInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/10/9.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChapterInfo: NSObject {
    // 章节id
    var chapterCode: Int!
    // 章节名称
    var chapterName: String?
    // 图片地址
    var chapterImgUrl: String?
    
    // 点击数量
    var clickNum = 0
    // 点赞数
    var score = 0
    var mediaType: Int?
    var mediaUrl: String?
    var teacher: String?
    var content: String?
    
    
    
    init(chapterCode: Int) {
        self.chapterCode = chapterCode
    }
    init(chapterJSON: JSON) {
        self.chapterCode  = chapterJSON["chapterCode"].int
        self.chapterName = chapterJSON["chapterName"].string
        self.chapterImgUrl = chapterJSON["chapterImgUrl"].string
        self.clickNum = chapterJSON["clickNum"].int ?? 0
        self.score = chapterJSON["score"].int ?? 0
        self.mediaType = chapterJSON["mediaType"].int
        self.mediaUrl = chapterJSON["mediaUrl"].string
        self.teacher = chapterJSON["teacher"].string
        self.content = chapterJSON["content"].string

    }
}
