//
//  ZhuanquMoreTableViewCell.swift
//  LiangYuan
//
//  Created by SN on 2017/11/22.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class ZhuanquMoreTableViewCell: UITableViewCell {
    
    // MARK:- Properties
    static let reuseIdentifier = "ZhuanquMoreTableViewCell"
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    var icon: UIImage? {
        get {
            return self.iconImageView.image
        }
        set {
            self.iconImageView.image = newValue
        }
    }
    var titleColor: UIColor? {
        get {
            return self.titleLabel.textColor
        }
        set {
            self.titleLabel.textColor = newValue
        }
    }
    
    // MARK:- UI Elements
    override var frame: CGRect {
        didSet {
            self.resetContentFrame()
        }
    }
    
    var titleLabel = UILabel()
    var iconImageView = UIImageView()
    private var separateView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
        resetContentFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func getCellHeight() -> CGFloat {
        return 80 * Constants.Scale
    }
    
    func setupUIElements() {
        
        self.backgroundColor = UIColor.clear
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.titleLabel.textAlignment = NSTextAlignment.left
        self.addSubview(titleLabel)
        
//        self.addSubview(iconImageView)
        
        separateView.backgroundColor = UIColor.black
        self.addSubview(separateView)
    }
    
    // MARK:- Update Frame
    private func resetContentFrame() {
        
        titleLabel.frame = CGRect(
            x: 20 * Constants.Scale,
            y: 20 * Constants.Scale,
            width: Constants.ScreenRect.width - 40 * Constants.Scale,
            height: 40 * Constants.Scale)
        
//        iconImageView.frame = CGRect(
//            x: 20 * Constants.Scale,
//            y: 20 * Constants.Scale,
//            width: 300 * Constants.Scale,
//            height: 40 * Constants.Scale)
        
        separateView.frame = CGRect(
            x: 0 * Constants.Scale,
            y: 80 * Constants.Scale - 1,
            width: Constants.ScreenRect.width,
            height: 1)
    }
}
