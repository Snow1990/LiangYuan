//
//  JinshenViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class JinshenViewController: BaseCollectionViewController {

    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.initData), userInfo: nil, repeats: true)
        initTabBar()
        initNav()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TabBar初始化
    func initTabBar() {
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "进深"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon4_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon4_pressed")
        
    }
    func initNav() {
        // 左边barbuttonitem
        let leftView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 600 * Constants.NavScale,
            height: 28 * Constants.NavScale))
        
        
        let leftImage = UIImage(named: "nav_icon1")
        let leftButton = UIButton(frame: CGRect(
            x: 0,
            y: -8 * Constants.NavScale,
            width: 44 * Constants.NavScale,
            height: 44 * Constants.NavScale))
        leftButton.setBackgroundImage(leftImage, for: UIControlState.normal)
        
        leftButton.setBackgroundImage(leftImage, for: UIControlState.highlighted)
        //        leftButton.addTarget(self, action: #selector(toggle), for: UIControlEvents.touchUpInside)
        
        // 边栏标题
        let sideMenuLabel = UILabel(frame: CGRect(
            x: 0 * Constants.NavScale,
            y: 0,
            width: 500 * Constants.NavScale,
            height: 32 * Constants.NavScale))
        sideMenuLabel.font = Constants.Font3
        sideMenuLabel.textColor = UIColor.black
        sideMenuLabel.tag = 1
        sideMenuLabel.text = "进深课程"
        
//        leftView.addSubview(leftButton)
        leftView.addSubview(sideMenuLabel)
        let leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
    }
    
    // MARK: - 从网络下载数据
    @objc func initData() {
        
        let url = Network.Domain + "subject/course/3"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let courseJSONArray = json["result"].array else {return}
            for courseJSON in courseJSONArray {
                let course = CourseInfo(courseJSON: courseJSON)
                self.courseInfoArray.append(course)
            }
            guard let timer1 = self.timer
                else{ return }
            timer1.invalidate()
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
