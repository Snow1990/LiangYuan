//
//  CoursePageViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/11/9.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoursePageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SNHomePageHeaderDelegate {
    
    var segmentIndex = 0
    var qihangCourseInfoArray = [CourseInfo]() {didSet{self.collectionView?.reloadData()}}
    var benkeCourseInfoArray = [CourseInfo]() {didSet{self.collectionView?.reloadData()}}
    var jinshenCourseInfoArray = [CourseInfo]() {didSet{self.collectionView?.reloadData()}}

    var timer: Timer!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        self.collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        initTabBar()
        initNav()
        initData()
//        timer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.initData), userInfo: nil, repeats: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segment.selectedSegmentIndex = segmentIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TabBar初始化
    func initTabBar() {
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "课程"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon3_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon3_pressed")
        
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
        sideMenuLabel.text = "课程列表"
        
        //        leftView.addSubview(leftButton)
        leftView.addSubview(sideMenuLabel)
        let leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
    }
    
    // MARK: - 从网络下载数据
    @objc func initData() {
        
        let url1 = Network.Domain + "subject/course/1"
        Alamofire.request(url1).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let courseJSONArray = json["result"].array else {return}
            for courseJSON in courseJSONArray {
                let course = CourseInfo(courseJSON: courseJSON)
                self.qihangCourseInfoArray.append(course)
            }
//            guard let timer1 = self.timer
//                else{ return }
//            timer1.invalidate()
        }
        
        let url2 = Network.Domain + "subject/course/2"
        Alamofire.request(url2).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let courseJSONArray = json["result"].array else {return}
            for courseJSON in courseJSONArray {
                let course = CourseInfo(courseJSON: courseJSON)
                self.benkeCourseInfoArray.append(course)
            }
//            guard let timer1 = self.timer
//                else{ return }
//            timer1.invalidate()
        }
        
        let url3 = Network.Domain + "subject/course/3"
        Alamofire.request(url3).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let courseJSONArray = json["result"].array else {return}
            for courseJSON in courseJSONArray {
                let course = CourseInfo(courseJSON: courseJSON)
                self.jinshenCourseInfoArray.append(course)
            }
//            guard let timer1 = self.timer
//                else{ return }
//            timer1.invalidate()
        }
    }
    
    // MARK: - Collection View 初始化
    func initCollectionView() {
        collectionView?.backgroundColor = Constants.HomePageBGColor
        //注册collectionCellID
        
        collectionView?.register(
            HomePageCollectionViewCell.classForCoder(),
            forCellWithReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier())
        
        //注册collection section header ID
        collectionView?.register(
            HomePageCollectionReusableHeader.classForCoder(),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier())
        
        //注册collection section footer ID
        collectionView?.register(
            HomePageCollectionReusableFooter.classForCoder(),
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: HomePageCollectionReusableFooter.reuseIdentifier())
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let segmentIndex = segment.selectedSegmentIndex
        switch segmentIndex {
        case 0: return qihangCourseInfoArray.count
        case 1: return benkeCourseInfoArray.count
        case 2: return jinshenCourseInfoArray.count
        default: return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var course = CourseInfo(courseCode: 0)
        let segmentIndex = segment.selectedSegmentIndex
        switch segmentIndex {
        case 0: course = qihangCourseInfoArray[section]
        case 1: course = benkeCourseInfoArray[section]
        case 2: course = jinshenCourseInfoArray[section]
        default: break
        }
        let row = course.chapters.count
        if row >= 2 {
            return 2
        }else {
            return row
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
        var course = CourseInfo(courseCode: 0)
        let segmentIndex = segment.selectedSegmentIndex
        switch segmentIndex {
        case 0: course = qihangCourseInfoArray[indexPath.section]
        case 1: course = benkeCourseInfoArray[indexPath.section]
        case 2: course = jinshenCourseInfoArray[indexPath.section]
        default: break
        }
        let chapter = course.chapters[indexPath.row]
        cell.title.text = chapter.chapterName
        cell.clickCountNum = chapter.clickNum
        cell.imageView.sd_setImage(with: URL(string: chapter.chapterImgUrl ?? ""), completed: nil)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableHeader
            headerView.section = indexPath.section
            var course = CourseInfo(courseCode: 0)
            let segmentIndex = segment.selectedSegmentIndex
            switch segmentIndex {
            case 0: course = qihangCourseInfoArray[indexPath.section]
            case 1: course = benkeCourseInfoArray[indexPath.section]
            case 2: course = jinshenCourseInfoArray[indexPath.section]
            default: break
            }
            
            headerView.label.text = course.courseName
            headerView.btn.setTitle("", for: UIControlState.normal)
            headerView.delegate = self
            headerView.backgroundColor = UIColor.clear
            return headerView
        } else {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomePageCollectionReusableFooter.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableFooter
            
            footView.backgroundColor = UIColor.clear
            return footView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomePageCollectionViewCell.getSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: Constants.Gap, bottom: 0, right: Constants.Gap)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.ScreenRect.width, height: 83 * Constants.Scale)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: Constants.ScreenRect.width, height: 20 * Constants.Scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var course = CourseInfo(courseCode: 0)
        let segmentIndex = segment.selectedSegmentIndex
        switch segmentIndex {
        case 0: course = qihangCourseInfoArray[indexPath.section]
        case 1: course = benkeCourseInfoArray[indexPath.section]
        case 2: course = jinshenCourseInfoArray[indexPath.section]
        default: break
        }
        
        let chapter = course.chapters[indexPath.row]
        //        print(chapter.chapterCode)
        performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: (chapter.chapterCode, DownloadType.chapter))
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CourseViewController, let id = sender as? Int, segue.identifier == Constants.ToCourseDetailSegue {
            destination.courseInfo = CourseInfo(courseCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ChapterViewController, let (id, type) = sender as? (Int , DownloadType), segue.identifier == Constants.ToChapterDetailSegue {
            destination.code = id
            destination.downloadType = type
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    // SNHomePageHeaderDelegate
    func snClickControl(headerView: HomePageCollectionReusableHeader, control: UIControl) {
        
        guard let section = headerView.section else {return}
        var course = CourseInfo(courseCode: 0)
        let segmentIndex = segment.selectedSegmentIndex
        switch segmentIndex {
        case 0: course = qihangCourseInfoArray[section]
        case 1: course = benkeCourseInfoArray[section]
        case 2: course = jinshenCourseInfoArray[section]
        default: break
        }
        performSegue(withIdentifier: Constants.ToCourseDetailSegue, sender: course.courseCode)
    }
    func snClickButton(headerView: HomePageCollectionReusableHeader, button: UIButton) {
        
    }
}
