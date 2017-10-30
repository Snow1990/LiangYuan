//
//  CourseInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class CourseInfo: NSObject {

    // 课程id
    var courseCode: Int!
    // 课程名称
    var courseName: String?
    // 类别id
    var subjectCode: Int?
    // 类别名称
    var subjectName: String?
    // 所有章节
    var chapters = [ChapterInfo]()
    var teacher: String?
    var courseDesc: String?
    
    init(courseCode: Int) {
        self.courseCode = courseCode
    }
    init(courseJSON: JSON) {
        self.courseCode  = courseJSON["courseCode"].int
        self.courseName = courseJSON["courseName"].string
        self.subjectCode = courseJSON["subjectCode"].int
        self.subjectName = courseJSON["subjectName"].string
        self.teacher = courseJSON["teacher"].string
        self.courseDesc = courseJSON["courseDesc"].string
        if let chaptersJSON = courseJSON["chapters"].array {
            for chapterJSON in chaptersJSON {
                let chapter = ChapterInfo(chapterJSON: chapterJSON)
                self.chapters.append(chapter)
            }
        }
    }
    

}
