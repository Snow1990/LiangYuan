//
//  AdScrollView.swift
//  LiangYuan
//
//  Created by SN on 2017/10/12.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SDWebImage

enum UIPageControlShowStyle {
    case Default
    case Left
    case Center
    case Right
}

protocol AdScrollViewDelegate: class {
    func selectCourse(index: Int)
}

class AdScrollView: UIScrollView, UIScrollViewDelegate {
    
    //MARK: - 定义参数
    weak var adScrollViewDelegate: AdScrollViewDelegate?
    //广告的label
    var adLable: UILabel?
    //循环滚动的三个视图
    var leftImageView = UIImageView()
    var centerImageView = UIImageView()
    var rightImageView = UIImageView()
    //循环滚动的周期时间
//    var moveTime = Timer()
    var pageControlShowStyle = UIPageControlShowStyle.Center
    var pageControl = UIPageControl()
    var newsInfoArray = [NewsInfo]() {
        didSet {
            pageControl.numberOfPages = newsInfoArray.count
            scrollViewDidEndDecelerating(self)
        }
    }
    
    //图片字典
    //    var imageDictionary = [String: UIImage]()
    
    //记录中间图片的下标
    var currentImageNum = 0
    let ChangeImageTime = 2.0
    
    
    //MARK: - 初始化，指定广告所占的frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        
        self.contentOffset = CGPoint(x: frame.width, y: 0)
        self.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        self.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectCourse))

        self.addGestureRecognizer(tapGesture)
        
        leftImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(leftImageView)
        centerImageView.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        self.addSubview(centerImageView)
        rightImageView.frame = CGRect(x: frame.width * 2, y: 0, width: frame.width, height: frame.height)
        self.addSubview(rightImageView)
//        moveTime = Timer.scheduledTimer(timeInterval: ChangeImageTime, target: self, selector: #selector(animalMoveImage), userInfo: nil, repeats: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //    //MARK: - 设置广告所使用的图片(名字)
    //    func setImageName(imageArray: [UIImage]) {
    //        self.imageArray = imageArray
    //    }
    
    //MARK: - 创建pageControl,指定其显示样式
    func setPageControlShowStyle() {
        pageControl.numberOfPages = newsInfoArray.count
        switch self.pageControlShowStyle {
        case .Default:
            pageControl = UIPageControl()
        case .Left:
            pageControl.frame = CGRect(
                x: 10,
                y: self.frame.origin.y + self.frame.height - 20,
                width: 20 * CGFloat(pageControl.numberOfPages),
                height: 20)
        case .Center:
            pageControl.frame = CGRect(
                x: 0,
                y: 0,
                width: 20 * CGFloat(pageControl.numberOfPages),
                height: 20)
            pageControl.center = CGPoint(x: self.frame.width/2,
                                         y: self.frame.origin.y + self.frame.height - 10)
        case .Right:
            pageControl.frame = CGRect(
                x: self.frame.width - 20 * CGFloat(pageControl.numberOfPages),
                y: self.frame.origin.y + self.frame.height - 20,
                width: 20 * CGFloat(pageControl.numberOfPages),
                height: 20)
        }
        pageControl.currentPage = 0
        pageControl.isEnabled = false
    }
    
    //由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
    @objc func addPageControl() {
        setPageControlShowStyle()
        self.superview?.addSubview(pageControl)
    }
    
    //MARK: - 计时器到时,系统滚动图片
    @objc func animalMoveImage() {
        self.setContentOffset(CGPoint(x:self.frame.width * CGFloat(2),y: 0), animated: true)
//        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(scrollViewDidEndDecelerating), userInfo: self, repeats: false)
        
    }
    
    //MARK: - 图片停止时,调用该函数使得滚动视图复用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.contentOffset.x == 0 {
            currentImageNum = getForward(currentImageNum)
            pageControl.currentPage = getForward(currentImageNum)
        }else if self.contentOffset.x == self.frame.width * 2 {
            currentImageNum = getNext(currentImageNum)
            pageControl.currentPage = getForward(currentImageNum)
        }
        updateUI()
        
        self.contentOffset = CGPoint(x: self.frame.width, y: 0)
        
        //手动控制图片滚动应该取消那个三秒的计时器
//        moveTime.fireDate = NSDate(timeIntervalSinceNow: ChangeImageTime)
    }
    func updateUI() {
        
        if newsInfoArray.count >= 3{
            let leftUrl = newsInfoArray[getForward(currentImageNum)].newsImgUrl
            leftImageView.sd_setImage(with: URL(string: leftUrl ?? ""))
            let centerUrl = newsInfoArray[currentImageNum].newsImgUrl
            centerImageView.sd_setImage(with: URL(string: centerUrl ?? ""))
            let rightUrl = newsInfoArray[getNext(currentImageNum)].newsImgUrl
            rightImageView.sd_setImage(with: URL(string: rightUrl ?? ""))
   
        }
    }

    
    @objc func selectCourse() {
        self.adScrollViewDelegate?.selectCourse(index: currentImageNum)
    }
    
    //MARK: - 公共方法
    func getForward(_ index: Int) -> Int {
        if newsInfoArray.isEmpty {
            return 0
        }
        if index <= 0 {
            return newsInfoArray.count - 1
        }else {
            return index - 1
        }
    }
    
    func getNext(_ index: Int) -> Int {
        if newsInfoArray.isEmpty {
            return 0
        }
        if index >= newsInfoArray.count - 1 {
            return 0
        }else {
            return index + 1
        }
    }
    
    
    
}
