//
//  AlubmsSubjectInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/11/8.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumsSubjectInfo: NSObject {

    // 类别id
    var subjectCode: Int?
    // 类别标题
    var subjectName: String?
    var albumses = [AlbumsInfo]()
    
    init(subjectCode: Int) {
        self.subjectCode = subjectCode
    }
    init(albumSubjectJSON: JSON) {
        
        self.subjectCode = albumSubjectJSON["subjectCode"].int
        self.subjectName = albumSubjectJSON["subjectName"].string
        if let albumsesJSON = albumSubjectJSON["albums"].array {
            for albumsJSON in albumsesJSON {
                let albums = AlbumsInfo(albumJSON: albumsJSON)

                self.albumses.append(albums)
            }
        }
    }
    
}
