//
//  AlbumsInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/11/8.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumsInfo: NSObject {

    // id
    var albumCode: Int?
    // 标题
    var title: String?
    // 类别id
    var subjectCode: Int?
    // 类别标题
    var subjectName: String?
    // 图片地址
    var coverImgUrl: String?
    var author: String?
    var content: String?
    var fileUrl: String?
    var fileType: Int?
    var dateTime: String?

    init(albumCode: Int) {
        self.albumCode = albumCode
    }
    init(albumJSON: JSON) {
        self.albumCode  = albumJSON["albumCode"].int
        self.title = albumJSON["title"].string
        self.subjectCode = albumJSON["subjectCode"].int
        self.subjectName = albumJSON["subjectName"].string
        self.coverImgUrl = albumJSON["coverImgUrl"].string
        self.author = albumJSON["author"].string
        self.content = albumJSON["content"].string
        self.fileUrl = albumJSON["fileUrl"].string
        self.fileType = albumJSON["fileType"].int
        self.dateTime = albumJSON["dateTime"].string

    }
}
