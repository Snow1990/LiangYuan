//
//  ChapterInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/10/9.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class ChapterInfo: NSObject {
    // 章节id
    var chapterCode: String?
    // 图片地址
    var chapterImgUrl: String?
    // 章节名称
    var chapterName: String?
    // 点击数量
    var clickNum = 0
    // 点赞数
    var score = 0
    
    
    init(chapterCode: String, chapterName: String) {
        self.chapterCode = chapterCode
        self.chapterName = chapterName
    }
}
