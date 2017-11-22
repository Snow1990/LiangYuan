//
//  ZhuanquViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/11/8.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZhuanquViewController: BaseCollectionViewController {

    var albumsTabInfoArray = [AlbumsTabInfo]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
//        timer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.initData), userInfo: nil, repeats: true)
        initTabBar()
        initNav()
        initData()
        collectionView?.register(
            ZhuanquCollectionViewCell.classForCoder(),
            forCellWithReuseIdentifier: ZhuanquCollectionViewCell.reuseIdentifier())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TabBar初始化
    func initTabBar() {
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "专区"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon6_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon6_pressed")
        
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
        sideMenuLabel.text = "专区"
        
        //        leftView.addSubview(leftButton)
        leftView.addSubview(sideMenuLabel)
        let leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
    }
    
    // MARK: - 从网络下载数据
    @objc func initData() {
        
        let url = Network.Domain + "album/tab"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            guard let albumsTabJSONArray = json["result"].array else {return}
            
            for albumsTabJSON in albumsTabJSONArray {
                let albumsTab = AlbumsTabInfo(albumsTabJSON: albumsTabJSON)
                self.albumsTabInfoArray.append(albumsTab)
            }
            guard let timer1 = self.timer
                else{ return }
            timer1.invalidate()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return albumsTabInfoArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let row = albumsTabInfoArray[section].children.count
        return row
//        if row >= 2 {
//            return 2
//        }else {
//            return row
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZhuanquCollectionViewCell.reuseIdentifier(), for: indexPath) as? ZhuanquCollectionViewCell else { return UICollectionViewCell() }
        let albumsTab = albumsTabInfoArray[indexPath.section]
        let child = albumsTab.children[indexPath.row]
        
        cell.title.text = child.subjectName
//        cell.clickCountNum = 0
////        cell.imageView.sd_setImage(with: URL(string: albums.fileUrl ?? ""), completed: nil)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableHeader
            headerView.section = indexPath.section
            headerView.label.text = albumsTabInfoArray[indexPath.section].subjectName
            headerView.btn.setTitle("", for: UIControlState.normal)
            headerView.moreLabel.text = ""
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
        return ZhuanquCollectionViewCell.getSize()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ZhuanquMoreViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsMoreSegue {
            destination.albumsSubjectInfo = AlbumsSubjectInfo(subjectCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ZhuanquDetailViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsDetailSegue {
            destination.albumsInfo = AlbumsInfo(albumCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ZhuanquMoreTableViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsMoreTableViewSegue {
            destination.subjectCode = id
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let child = albumsTabInfoArray[indexPath.section].children[indexPath.row]
        performSegue(withIdentifier: Constants.ToAlbumsMoreTableViewSegue, sender: child.subjectCode)
    }
    override func snClickControl(headerView: HomePageCollectionReusableHeader, control: UIControl) {
        
        guard let section = headerView.section else {return}
        let albumsTab = albumsTabInfoArray[section]
        performSegue(withIdentifier: Constants.ToAlbumsMoreTableViewSegue, sender: albumsTab.subjectCode)
    }

}
