//
//  ZhuanquDetailViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/11/9.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZhuanquDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var albumsInfo: AlbumsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNav()
        initData()
//        guard let content = albumsInfo?.content else {return}
//        self.webView.loadHTMLString(content, baseURL: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initNav() {
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = albumsInfo?.title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
    }
    func initData() {
        guard let albumCode = albumsInfo?.albumCode else {return}
        let url = Network.Domain + "album/one/\(albumCode)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let content = json["result"]["content"].string else {return}
            self.webView.loadHTMLString(content, baseURL: nil)
            
//            guard let courseJSONArray = json["result"].array else {return}
//            for courseJSON in courseJSONArray {
//                let course = CourseInfo(courseJSON: courseJSON)
//                self.courseInfoArray.append(course)
//            }
//            guard let timer1 = self.timer
//                else{ return }
//            timer1.invalidate()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
