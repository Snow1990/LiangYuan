//
//  ZhuanquMoreViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/11/19.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZhuanquMoreViewController: BaseCollectionViewController {
    
    var albumsSubjectInfo: AlbumsSubjectInfo? {
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
        
//        let teacher = courseInfo?.teacher
//        let rightBtn = UIBarButtonItem(title: teacher, style: .plain, target: nil, action: nil)
//        self.navigationItem.rightBarButtonItem = rightBtn
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = albumsSubjectInfo?.subjectName
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
    }
    
    // MARK: - 从网络下载数据
    func initData() {
        guard let code = albumsSubjectInfo?.subjectCode else {return}
        
        //下载章节页数据
        let url = Network.Domain + "album/list/\(code)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
//            print(json)
//            let course = CourseInfo(courseJSON: json["result"])
            guard let albumsJSONArray = json["result"].array else {return}
            let tmp = AlbumsSubjectInfo(subjectCode: code)
            for albumsJSON in albumsJSONArray {
                let albums = AlbumsInfo(albumJSON: albumsJSON)
                tmp.albumses.append(albums)
            }
            self.albumsSubjectInfo = tmp
            
//            let course = CourseInfo(courseJSON: json["result"])
//            self.courseInfo = course
            //            self.courseInfoArray.append(course)
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
        if let albumsSubject = albumsSubjectInfo {
            return albumsSubject.albumses.count
        }else {
            return 0
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
        guard let albumsSubject = albumsSubjectInfo else {return UICollectionViewCell()}
        let albums = albumsSubject.albumses[indexPath.row]
        cell.title.text = albums.title
        cell.clickCountNum = 0
        cell.imageView.sd_setImage(with: URL(string: albums.fileUrl ?? ""), completed: nil)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableHeader
            
            headerView.label.text = albumsSubjectInfo?.subjectName
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
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //        let attibute = [NSAttributedStringKey.font : Constants.Font3]
        //        let height = CourseCollectionReusableHeader.autoLabelHeight(with: courseInfo?.courseDesc, labelWidth: Constants.ScreenRect.width - 10, attributes: attibute)
        
        return CGSize(width: Constants.ScreenRect.width, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let albums = albumsSubjectInfo?.albumses[indexPath.row]{
            performSegue(withIdentifier: Constants.ToAlbumsDetailSegue, sender: albums.albumCode)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? ZhuanquDetailViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsDetailSegue {
            destination.albumsInfo = AlbumsInfo(albumCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
        
}
