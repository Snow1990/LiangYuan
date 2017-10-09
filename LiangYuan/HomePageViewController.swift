//
//  HomePageViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var homePageCollectionView: UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        
        self.initTabBar()
        
        self.initCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        
    }
    
    func initTabBar(){
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "首页"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon1_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon1_pressed")
    }

    func initCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        homePageCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        homePageCollectionView!.backgroundColor = UIColor.blue
        homePageCollectionView!.isOpaque = false
        homePageCollectionView!.frame = CGRect(
            x: 0, y: 44,
            width: 720 * Constants.Scale,
            height: 1280 * Constants.Scale - 44)
        
        self.view.addSubview(homePageCollectionView!)
    }
    // MARK: - Collection View 初始化
//    func initCollectionView() {
//        
//        homePageCollectionView.dataSource = self
//        homePageCollectionView.delegate = self
//        
//        //注册collectionCellID
//        homePageCollectionView.registerClass(CourseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: Constants.HomePageReusableCellID)
//        //注册广告页CellID
//        homePageCollectionView.registerClass(CourseAdCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: Constants.HomePageAdReusableCellID)
//        //注册collection section header ID
//        homePageCollectionView.registerClass(CourseCollectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.CollectionHeaderViewReusableCellID)
//        //注册collection section footer ID
//        homePageCollectionView.registerClass(CourseCollectionFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.CollectionFooterViewReusableCellID)
//    }
    
    
    // MARK: - Collection data sourse
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test1", for: indexPath) as! AdCollectionViewCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    // MARK: - Collection delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        print("select")
    }
    
        
    // MARK: - UICollectionViewDelegateFlowLayout
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
