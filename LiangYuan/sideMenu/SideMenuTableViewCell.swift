//
//  SideMenuTableViewCell.swift
//  LiangYuan
//
//  Created by SN on 2017/10/13.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func reuseIdentifier() -> String{
        return Constants.SideMenuReusableCellID
    }
    
    class func getCellHeight() -> CGFloat {
        return 96 * Constants.Scale
    }
}
