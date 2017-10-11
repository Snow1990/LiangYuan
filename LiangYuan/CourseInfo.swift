//
//  CourseInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class CourseInfo: NSObject {

    // 课程id
    var courseCode: String!
    // 课程名称
    var courseName: String!
    // 类别id
    var subjectCode: String?
    // 类别名称
    var subjectName: String?
    // 所有章节
    var chapters = [ChapterInfo]()
    
    
    
    init(courseCode: String, courseName: String) {
        self.courseCode = courseCode
        self.courseName = courseName
    }

}
