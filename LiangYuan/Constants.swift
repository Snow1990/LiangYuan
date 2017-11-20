//
//  Constants.swift
//  LiangYuan
//
//  Created by SN on 2017/9/27.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

struct Constants {

    // NSUserDefault中键值名
    static let FirstLaunchNUD = "LiangyuanFirstLaunch"
    
    
    // 场景过度
    static let ToAdDetailSegue = "toAdDetailSegue"
    static let ToCourseDetailSegue = "toCourseDetailSegue"
    static let ToChapterDetailSegue = "toChapterDetailSegue"
    static let ToAlbumsMoreSegue = "toAlbumsMoreSegue"

    static let ToAlbumsDetailSegue = "toAlbumsDetailSegue"

    
    // 可重用cellID
    static let HomePageReusableCellID = "HomePageCell"
    static let HomePageAdReusableCellID = "HomePageAdCell"
    static let SideMenuReusableCellID = "SideMenuCell"
    static let PopularRecomendReusableCellID = "SearchResultCell"
    static let SearchResultReusableCellID = "PopularRecomendCell"
    static let CourseCommentReusableCellID = "CourseCommentCell"
    static let CollectionHeaderViewReusableCellID = "CollectionHeaderView"
    static let CollectionFooterViewReusableCellID = "CollectionFooterView"
    static let CollectionLoadingViewReusableCellID = "CollectionLoadingView"
    static let PopularRecomendHeaderReusableCellID = "PopularRecomendHeader"
    
    
    // 颜色
//    static let HomePageBGColor = UIColor(red: 50/256, green: 93/256, blue: 106/256, alpha: 1)
    static let HomePageBGColor = UIColor(red: 245/256, green: 245/256, blue: 245/256, alpha: 1)
    static let NavBGColor = UIColor(red: 176/256, green: 93/256, blue: 40/256, alpha: 1)
    static let TabBGColor = UIColor(red: 147/256, green: 74/256, blue: 66/256, alpha: 1)
    static let TabViewBGGreen = UIColor(red: 217/255, green: 247/255, blue: 217/255, alpha: 0.8)
    static let SideMenuBGColor = UIColor(red: 37/255, green: 155/255, blue: 36/255, alpha: 0.75)
    static let SelectedBGColor = UIColor(red: 240/255, green: 247/255, blue: 242/255, alpha: 1)
    static let SeparateColor = UIColor(red: 219/255, green: 225/255, blue: 221/255, alpha: 1)
    static let LectureBGColor = UIColor(red: 220/255, green: 221/255, blue: 223/255, alpha: 1)
    
    static let MainColor = UIColor(red: 37/255, green: 155/255, blue: 36/255, alpha: 1)
    static let backgroundColor = UIColor(red: 241/255, green: 248/255, blue: 240/255, alpha: 1)
    static let AssistColor1 = UIColor(red: 163/255, green: 233/255, blue: 164/255, alpha: 1)
    static let AssistColor2 = UIColor(red: 249/255, green: 212/255, blue: 10/255, alpha: 1)
    static let AssistColor3 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.87)
    static let AssistColor4 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.73)
    static let AssistColor5 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.54)
    static let AssistColor6 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let AssistColor7 = UIColor(red: 5/255, green: 111/255, blue: 0/255, alpha: 1)
    
    // 字体
    static let Font1 = UIFont.boldSystemFont(ofSize: 12)
    static let Font2 = UIFont.boldSystemFont(ofSize: 14)
    static let Font3 = UIFont.boldSystemFont(ofSize: 18)
    static let Font4 = UIFont.boldSystemFont(ofSize: 20)


    
    // 和设计图比例 720*1280 360*640
    static let ScreenRect = UIScreen.main.bounds
    static let Scale = ScreenRect.width/720
    static let NavScale: CGFloat = 44/96
    static let Gap: CGFloat = 10 * Constants.Scale

    
}
