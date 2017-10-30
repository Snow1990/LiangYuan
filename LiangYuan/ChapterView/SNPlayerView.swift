//
//  SNPlayerView.swift
//  PlayerTest
//
//  Created by SN on 2017/10/23.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

protocol SNPlayerViewDelegate:NSObjectProtocol {
    func snplayer(playerView: SNPlayerView, sliderTouchUpOut slider: UISlider)
    func snplayer(playerView:SNPlayerView,playAndPause playBtn:UIButton)
}

class SNPlayerView: UIView {

    var timeLabel:UILabel!
    var playerLayer:AVPlayerLayer? {
        didSet {
            layoutSubviews()
        }
    }
    var slider:UISlider!
    var sliding = false
    var playing = false
    var progressView:UIProgressView!
    var playBtn:UIButton!
    weak var delegate:SNPlayerViewDelegate?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.darkGray
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.text = "00:00/00:00"
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(self).inset(5)
        }
        
        slider = UISlider()
        self.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).inset(100)
            make.height.equalTo(15)
        }
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.white
        // 在滑块圆按钮添加图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: UIControlState.normal)
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown(slider:)), for: UIControlEvents.touchDown)
        
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: UIControlEvents.touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: UIControlEvents.touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: UIControlEvents.touchCancel)
        
        progressView = UIProgressView()
        progressView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        self.insertSubview(progressView, belowSubview: slider)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(slider)
            make.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        progressView.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        progressView.progress = 0
        
        playBtn = UIButton()
        self.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
        // 设置按钮图片
        playBtn.setImage(UIImage(named: "player_play"), for: UIControlState.normal)
        // 点击事件
        playBtn.addTarget(self, action: #selector(playAndPause(btn:)), for: UIControlEvents.touchUpInside)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    @objc func sliderTouchDown(slider:UISlider){
        self.sliding = true
    }
    @objc func sliderTouchUpOut(slider:UISlider){
        // TODO: -代理处理
        delegate?.snplayer(playerView: self, sliderTouchUpOut: slider)
    }
    @objc func playAndPause(btn:UIButton){
        let tmp = !playing
        playing = tmp // 改变状态
        
        // 根据状态设定图片
        if playing {
            playBtn.setImage(UIImage(named: "player_pause"), for: UIControlState.normal)
        }else{
            playBtn.setImage(UIImage(named: "player_play"), for: UIControlState.normal)
        }
        
        // 代理方法
        delegate?.snplayer(playerView: self, playAndPause: btn)
    }
}
