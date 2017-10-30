//
//  CourseCollectionReusableHeader.swift
//  LiangYuan
//
//  Created by SN on 2017/10/17.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import SnapKit

class CourseCollectionReusableHeader: UICollectionReusableView {
    var introduce = "" {
        didSet {
            self.reloadFrame()
        }
    }
    var textView = UITextView()
    var introduceLabel = UILabel()
    var bgControl = UIControl()
    //    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 标题
        
        introduceLabel.frame = self.bounds
        introduceLabel.textColor = UIColor.white
        introduceLabel.numberOfLines = 0
        introduceLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        introduceLabel.font = Constants.Font3
        self.addSubview(introduceLabel)
        
        
        
    }
    func reloadFrame() {
        
        let attibute = [NSAttributedStringKey.font : Constants.Font3]
        let height = CourseCollectionReusableHeader.autoLabelHeight(with: introduce, labelWidth: Constants.ScreenRect.width - 10, attributes: attibute)
        self.introduceLabel.text = introduce
        self.introduceLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).inset(5)
            make.height.equalTo(height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func reuseIdentifier() -> String{
        return "CourseCollectionReusableHeaderReuseIdentifier"
    }
    func getSize() -> CGSize {
        return introduceLabel.bounds.size
    }
    
    func resetIntroduceLabel () {
        
    }
    ///label高度自适应
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - labelWidth: 最大宽度
    ///   - attributes: 字体，行距等
    /// - Returns: 高度
    class func autoLabelHeight(with text:String? , labelWidth: CGFloat ,attributes : [NSAttributedStringKey : Any]) -> CGFloat{
        guard let text = text else {return 0}
        var size = CGRect()
        let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return size.size.height
    }

    
}
