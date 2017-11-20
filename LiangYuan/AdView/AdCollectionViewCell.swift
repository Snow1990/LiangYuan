//
//  AdCollectionViewCell.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    
    var scrollView: AdScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = AdScrollView(frame: frame)
        scrollView.backgroundColor = UIColor.gray
        self.addSubview(scrollView)
        
        scrollView.pageControl.pageIndicatorTintColor = UIColor.white
        scrollView.pageControl.currentPageIndicatorTintColor = Constants.AssistColor1
        scrollView.addPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    class func reuseIdentifier() -> String{
        return Constants.HomePageAdReusableCellID
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: Argument.CellWidth, height: Argument.CellHeight)
    }
    private struct Argument {
        
        //广告页宽高比
        //        static let Scale:CGFloat = 19/8
        static let CellWidth: CGFloat = Constants.ScreenRect.width
        static let CellHeight: CGFloat = Constants.ScreenRect.width/64*24
        //        static let AdPageControlWidth: CGFloat = CellWidth/5
        //        static let AdPageControlHeight: CGFloat = 10
        //        static let AdPageNumber: Int = 5
    }
}
