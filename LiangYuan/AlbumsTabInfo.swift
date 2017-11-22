//
//  AlbumsTabInfo.swift
//  LiangYuan
//
//  Created by SN on 2017/11/22.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumsTabInfo: NSObject {

    // 类别id
    var subjectCode: Int?
    // 类别标题
    var subjectName: String?
    var children = [AlbumsTabInfo]()
    
    init(subjectCode: Int) {
        self.subjectCode = subjectCode
    }
    init(albumsTabJSON: JSON) {
        
        self.subjectCode = albumsTabJSON["subjectCode"].int
        self.subjectName = albumsTabJSON["subjectName"].string
        if let childrenJSON = albumsTabJSON["children"].array {
            for albumsTabJSON in childrenJSON {
                let child = AlbumsTabInfo(albumsTabJSON: albumsTabJSON)
                
                self.children.append(child)
            }
        }
    }
}
