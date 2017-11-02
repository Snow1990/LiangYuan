//
//  AdDetailViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/30.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class AdDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var newsInfo: NewsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let id = newsInfo?.newsCode else { return }
//        if id == 1 {
//        }
        initNav()
        let url = URL(string: "https://www.lediaocha.com/pc/s/ivduey")
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
        
    }

    func initNav() {
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = "调查问卷"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
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
