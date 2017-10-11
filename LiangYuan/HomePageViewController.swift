//
//  HomePageViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire

class HomePageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var homePageCollectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()
    private let HomeCollectionCellIdentifier = "HomeCollectionCell"
    private let HomeFooterViewIdentifier = "HomeFooterView"
    private let HomeAdCollectionCellIdentifier = "HomeAdCollectionCell"
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        
        self.initTabBar()
        
        self.initCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCellIdentifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test1", for: indexPath) as! AdCollectionViewCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    // MARK: - Collection delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        print("select")
    }
    
        
    // MARK: - UICollectionViewDelegateFlowLayout
    
    
    // MARK: Helper
    
    func initData() {
        
        Alamofire.request("https://api.500px.com/v1/photos", method: .get).responseJSON {
            response in
            guard let JSON = response.result.value else { return }
            print("JSON: \(JSON)")
        }
        
        
        
    }
    
    func initTabBar(){
        //tabBarItem的image属性必须是png格式（建议大小32*32）并且打开alpha通道否则无法正常显示。
        self.navigationController?.tabBarItem.title = "首页"
        self.navigationController?.tabBarItem.image = UIImage(named: "table_icon1_normal")
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "table_icon1_pressed")
    }
    
    func initCollectionView() {
        homePageCollectionView?.dataSource = self
        homePageCollectionView?.delegate = self

        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard let collectionView = homePageCollectionView else { return }
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 2) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 100)
        
        collectionView.collectionViewLayout = layout
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = "Photomania"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
        
        collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionCellIdentifier)
        collectionView.register(HomeCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomeFooterViewIdentifier)
        
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        
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
    private dynamic func handleRefresh() {
        
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

class HomeCollectionViewCell: UICollectionViewCell {
    fileprivate let imageView = UIImageView()
    fileprivate var request: Request?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        imageView.frame = bounds
        addSubview(imageView)
    }
}
class HomeCollectionViewLoadingCell: UICollectionReusableView {
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spinner.startAnimating()
        spinner.center = center
        addSubview(spinner)
    }
}
