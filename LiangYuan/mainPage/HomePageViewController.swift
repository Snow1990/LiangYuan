//
//  HomePageViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomePageViewController: BaseCollectionViewController {

    var timer: Timer!
    var newsInfoArray = [NewsInfo]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    var albumsInfoArray = [AlbumsInfo]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initTabBar()
        initNav()
        initData()
//        timer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.initData), userInfo: nil, repeats: true)

    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.collectionView?.reloadData()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TabBar初始化
    func initTabBar() {
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "首页"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon1_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon1_pressed")
        
    }
    func initNav() {
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = "良友圣经学院"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
    }
    
    // MARK: - 从网络下载数据
    @objc func initData() {
        
        //下载广告页数据
        let url = Network.Domain + "index"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            if let newsJSONArray = json["result"]["banners"].array {
                for newsJSON in newsJSONArray {
                    let news = NewsInfo(newsJSON: newsJSON)
                    self.newsInfoArray.append(news)
                }
            }
            if let albumsJSONArray = json["result"]["albums"].array {
                for albumsJSON in albumsJSONArray {
                    let albums = AlbumsInfo(albumJSON: albumsJSON)
                    albums.title = albumsJSON["albumTitle"].string
                    self.albumsInfoArray.append(albums)
                }
                
            }
            
            if let courseJSONArray = json["result"]["subjects"].array {
                for courseJSON in courseJSONArray {
                    let course = CourseInfo(courseJSON: courseJSON)
                    self.courseInfoArray.append(course)
                    
                }
            }

            guard let timer1 = self.timer
                else{ return }
            timer1.invalidate()
        }
    }
    
    override func initCollectionView() {
        super.initCollectionView()
        collectionView?.register(AdCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: AdCollectionViewCell.reuseIdentifier())
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        print(courseInfoArray.count)
        return courseInfoArray.count + 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return 1
        }else if section == 1{
            return albumsInfoArray.count
        }else {
            let row = courseInfoArray[section - 2].chapters.count
            if row >= 2 {
                return 2
            }else {
                return row
            }
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.reuseIdentifier(), for: indexPath) as? AdCollectionViewCell {
                cell.scrollView.newsInfoArray = self.newsInfoArray
                cell.scrollView.adScrollViewDelegate = self
                return cell
            }
        }else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
            let albums = albumsInfoArray[indexPath.row]
            cell.title.text = albums.title
            cell.clickCountNum = 0
            cell.imageView.sd_setImage(with: URL(string: albums.fileUrl ?? ""), completed: nil)
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
            let course = courseInfoArray[indexPath.section - 2]
            let chapter = course.chapters[indexPath.row]
            
            cell.title.text = chapter.chapterName
            cell.clickCountNum = chapter.clickNum
            cell.imageView.sd_setImage(with: URL(string: chapter.chapterImgUrl ?? ""), completed: nil)
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableHeader
            
            guard indexPath.section != 0 else {return headerView}
            guard indexPath.section != 1 else {return headerView}
            headerView.section = indexPath.section-2
            headerView.label.text = courseInfoArray[indexPath.section-2].courseName
            if let subject = courseInfoArray[indexPath.section-2].subjectName {
                headerView.btn.setTitle(subject, for: UIControlState.normal)
            }
            headerView.delegate = self
            headerView.backgroundColor = UIColor.clear
            return headerView
        } else {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomePageCollectionReusableFooter.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableFooter
            footView.backgroundColor = UIColor.clear
            return footView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return AdCollectionViewCell.getSize()
        }else {
            return HomePageCollectionViewCell.getSize()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            
            let Gap: CGFloat = 8 * Constants.Scale
            return UIEdgeInsets(top: 0, left: Gap, bottom: 0, right: Gap)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 || section == 1{
            return CGSize(width: Constants.ScreenRect.width, height: 0)
        }else {
            return CGSize(width: Constants.ScreenRect.width, height: 83 * Constants.Scale)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: Constants.ScreenRect.width, height: 0)
        }else {
            return CGSize(width: Constants.ScreenRect.width, height: 20 * Constants.Scale)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {

        }else if indexPath.section == 1 {
            let albums = albumsInfoArray[indexPath.row]
//            if let mp3URL = albums.fileUrl {
//                if mp3URL != "" {
//                    performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: (albums.albumCode, DownloadType.albums))
//                    return
//                }
//            }
            performSegue(withIdentifier: Constants.ToAlbumsDetailSegue, sender: albums.albumCode)
        }else {
            let chapter = courseInfoArray[indexPath.section  - 2].chapters[indexPath.row]
            performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: (chapter.chapterCode, DownloadType.chapter))
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? AdDetailViewController, let id = sender as? Int, segue.identifier == Constants.ToAdDetailSegue {
            
            destination.newsInfo = NewsInfo(newsCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ZhuanquDetailViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsDetailSegue {
            
            destination.albumsInfo = AlbumsInfo(albumCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    func firstLaunch() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: Constants.FirstLaunchNUD){
            
            userDefaults.setValue(true, forKey: Constants.FirstLaunchNUD)
            userDefaults.synchronize()
        }
    }
    
    
    override func snClickButton(headerView: HomePageCollectionReusableHeader, button: UIButton) {
        guard let section = headerView.section else {return}
        guard let subjectCode = courseInfoArray[section].subjectCode else {return}
        switch subjectCode {
        case 1:
            self.tabBarController?.selectedIndex = 1
//            if let controllers = self.tabBarController?.viewControllers{
//                if let ctr = controllers[1].childViewControllers[0] as? CoursePageViewController {
//                    
//                    ctr.segment.selectedSegmentIndex = 1
//                }
//
//            }
        case 2:
            self.tabBarController?.selectedIndex = 1
        case 3:
            self.tabBarController?.selectedIndex = 1
        case 4:
            self.tabBarController?.selectedIndex = 2
        default:
            return
        }
    }
}
extension HomePageViewController: AdScrollViewDelegate {
    func selectCourse(index: Int) {
        if index == 0 {
            performSegue(withIdentifier: Constants.ToAdDetailSegue, sender: index)
        }
    }
    
}

