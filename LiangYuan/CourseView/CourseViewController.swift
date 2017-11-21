//
//  CourseViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CourseViewController: BaseCollectionViewController {
    var courseInfo: CourseInfo? {
        didSet {
            initNav()
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initTabBar()
//        initNav()
        initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TabBar初始化
    func initTabBar() {
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.tabBarController?.tabBar.isHidden = true        
    }
    
    func initNav() {
        
        let teacher = courseInfo?.teacher
        let rightBtn = UIBarButtonItem(title: teacher, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = courseInfo?.courseName
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
    }
    
    // MARK: - 从网络下载数据
    func initData() {
        
        guard let code = courseInfo?.courseCode else {return}
        //下载章节页数据
        let url = Network.Domain + "course/one/\(code)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            let course = CourseInfo(courseJSON: json["result"])
            self.courseInfo = course
        }
        
        
        
    }
    
    override func initCollectionView() {
        super.initCollectionView()
        //注册collection section header ID
        collectionView?.register(
            CourseCollectionReusableHeader.classForCoder(),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: CourseCollectionReusableHeader.reuseIdentifier())
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let course = courseInfo {
            return course.chapters.count
        }else {
            return 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
        guard let course = courseInfo else {return UICollectionViewCell()}
        let chapter = course.chapters[indexPath.row]
        
        cell.title.text = chapter.chapterName
        cell.clickCountNum = chapter.clickNum
        cell.imageView.sd_setImage(with: URL(string: chapter.chapterImgUrl ?? ""), completed: nil)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView?
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CourseCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! CourseCollectionReusableHeader
            
            
            headerView.introduce = courseInfo?.courseDesc ?? ""
            reusableView = headerView
            reusableView!.backgroundColor = UIColor.clear
        } else {
            
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomePageCollectionReusableFooter.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableFooter
            reusableView = footView
            reusableView!.backgroundColor = UIColor.clear
        }
        return reusableView!
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let attibute = [NSAttributedStringKey.font : Constants.Font3]
//        let height = CourseCollectionReusableHeader.autoLabelHeight(with: courseInfo?.courseDesc, labelWidth: Constants.ScreenRect.width - 10, attributes: attibute)
      
        return CGSize(width: Constants.ScreenRect.width, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let course = courseInfo {
            let chapter = course.chapters[indexPath.row]
            performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: chapter.chapterCode)

        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? ChapterViewController, let id = sender as? Int, segue.identifier == Constants.ToChapterDetailSegue {
//            destination.chapterInfo = ChapterInfo(chapterCode: id)
//            destination.hidesBottomBarWhenPushed = true
//        }
//    }
    

}
