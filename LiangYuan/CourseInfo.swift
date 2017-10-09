//
//  CourseInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class CourseInfo: NSObject {

    //课程ID
    var id: String!
    //课程名称
    var name: String!
    //总点击量
    var hits: Int?
    //平均星级得分
    var avgStarScore: Double?
    //课程banner图片的相对路径
    var imagePath: String?
    //课程来源
    var sourceName: String?
    
    
    //课程小类ID
    var minTypeId: String?
    //课程小类名称
    var minTypeName: String?
    //课程视频播放参数unique
    var unique: String?
    //描述或简介
    var courseDescription: String?
//    //讲师
//    var lectureInfo: LectureInfo?
    //true：已收藏；false：未收藏
    var favorites = false
    
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

}
