//
//  ZhuanquDetailWithVoiceVC.swift
//  LiangYuan
//
//  Created by SN on 2017/11/22.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZhuanquDetailWithVoiceVC: ChapterViewController {


    
    // MARK: - 从网络下载数据
    func initData() {
        //下载章节页数据
        let url = Network.Domain + "album/one/\(code)"
        
        Alamofire.request(url).responseJSON { [unowned self] (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            let albums = AlbumsInfo(albumJSON: json["result"])
            self.navTitle = albums.title
            self.mp3URL = albums.fileUrl
            self.content = albums.content
        }
    }
}
