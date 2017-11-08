//
//  BaseCollectionViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SDWebImage


class BaseCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,SNHomePageHeaderDelegate {

    var courseInfoArray = [CourseInfo]() {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return courseInfoArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let row = courseInfoArray[section].chapters.count
        if row >= 2 {
            return 2
        }else {
            return row
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.reuseIdentifier(), for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
        let course = courseInfoArray[indexPath.section]
        let chapter = course.chapters[indexPath.row]
        
        cell.title.text = chapter.chapterName
        cell.clickCountNum = chapter.clickNum
        cell.imageView.sd_setImage(with: URL(string: chapter.chapterImgUrl ?? ""), completed: nil)

        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomePageCollectionReusableHeader.reuseIdentifier(), for: indexPath) as! HomePageCollectionReusableHeader
            headerView.section = indexPath.section
            headerView.label.text = courseInfoArray[indexPath.section].courseName
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
        let Gap: CGFloat = 8 * Constants.Scale
        return UIEdgeInsets(top: 0, left: Gap, bottom: 0, right: Gap)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.ScreenRect.width, height: 83 * Constants.Scale)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: Constants.ScreenRect.width, height: 20 * Constants.Scale)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = courseInfoArray[indexPath.section].chapters[indexPath.row]
//        print(chapter.chapterCode)
        performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: chapter.chapterCode)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CourseViewController, let id = sender as? Int, segue.identifier == Constants.ToCourseDetailSegue {
            destination.courseInfo = CourseInfo(courseCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ChapterViewController, let id = sender as? Int, segue.identifier == Constants.ToChapterDetailSegue {
            destination.chapterInfo = ChapterInfo(chapterCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
    // SNHomePageHeaderDelegate
    func snClickControl(headerView: HomePageCollectionReusableHeader, control: UIControl) {
        
        guard let section = headerView.section else {return}
        let course = courseInfoArray[section]
        performSegue(withIdentifier: Constants.ToCourseDetailSegue, sender: course.courseCode)
    }
    func snClickButton(headerView: HomePageCollectionReusableHeader, button: UIButton) {
        
    }
}

