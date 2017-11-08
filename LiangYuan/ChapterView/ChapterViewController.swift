//
//  ChapterViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/10/18.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ChapterViewController: UIViewController {
    // MARK:- Properties
    var chapterInfo: ChapterInfo? {
        didSet {
            initNav()
            
        }
    }
    var isFirstLaunch = true
    var isError = false
    // MARK:- UI Elements
    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var link:CADisplayLink!
    var timer: Timer!
    @IBOutlet weak var playerView: SNPlayerView!
    @IBOutlet weak var webView: UIWebView!

    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNav()
        initData()
        self.playerView.delegate = self

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let timer1 = self.timer
            else{ return }
        timer1.invalidate()
    }
    
    func initNav() {
        let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
        
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
        titleLabel.text = chapterInfo?.chapterName
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        navigationItem.titleView = titleLabel
    }
    
    // MARK:- 初始化播放器
    func initPlayerView() {

        // 检测连接是否存在 不存在报错
        guard let url = URL(string: chapterInfo?.mediaUrl ?? "") else {
            showError(reason: "音频链接错误")
            self.isError = true
            return
        }
//        guard let url = URL(string: "http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4") else { fatalError("链接错误") }
        playerItem = AVPlayerItem(url: url) // 创建视频资源
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 将视频资源赋值给视频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
        // 初始化视频显示layer
        playerLayer = AVPlayerLayer(player: avplayer)
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        // 赋值给自定义的View
        self.playerView.playerLayer = self.playerLayer
        // 位置放在最底下
        self.playerView.layer.insertSublayer(playerLayer, at: 0)
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as?AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges" {
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime // 计算出比例
            // 改变进度条
            self.playerView.progressView.progress = Float(percent)
        }else if keyPath == "status" {
            // 监听状态改变
            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                // 只有在这个状态下才能播放
                self.avplayer.play()
            }else {
                showError(reason: "音频加载异常")
            }
        }
    }
    
    @objc func update(){
        //暂停的时候
        if !self.playerView.playing{
            return
        }
        // 当前播放到的时间
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        // 总时间
        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        // timescale 这里表示压缩比例
        let timeStr = "\(formatPlayTime(secounds: currentTime))/\(formatPlayTime(secounds: totalTime))" // 拼接字符串
        playerView.timeLabel.text = timeStr // 赋值
        // TODO: 播放进度
        // 滑动不在滑动的时候
        if !self.playerView.sliding{
            // 播放进度
            self.playerView.slider.value = Float(currentTime/totalTime)
        }
        
    }
    
    deinit{
        if !self.isFirstLaunch && !self.isError {
            playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
            playerItem.removeObserver(self, forKeyPath: "status")
        }
        
    }
    
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = avplayer?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    func showError(reason: String) {
        self.playerView.delegate = nil
        let alertView = UIAlertView(title: reason, message: "", delegate: self, cancelButtonTitle: "取消")
        alertView.show()
    }
    // MARK: - 从网络下载数据
    func initData() {
        guard let code = chapterInfo?.chapterCode else {return}
        //下载章节页数据
        let url = Network.Domain + "course/chapter/one/\(code)"
        
        Alamofire.request(url).responseJSON { [unowned self] (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            let chapter = ChapterInfo(chapterJSON: json["result"])
            self.chapterInfo = chapter
            self.webView.loadHTMLString(chapter.content ?? "", baseURL: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChapterViewController:SNPlayerViewDelegate{
    // 滑动滑块 指定播放位置
    func snplayer(playerView: SNPlayerView, sliderTouchUpOut slider: UISlider) {
        
        //当视频状态为AVPlayerStatusReadyToPlay时才处理
        if self.avplayer.status == AVPlayerStatus.readyToPlay{
            let duration = slider.value * Float(CMTimeGetSeconds(self.avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            // 指定视频位置
            self.avplayer.seek(to: seekTime, completionHandler: { (b) in
                // 别忘记改状态
                playerView.sliding = false
            })
        }
    }
    func snplayer(playerView: SNPlayerView, playAndPause playBtn: UIButton) {
        // 第一次启动时 初始化视频播放
        if self.isFirstLaunch {
            playBtn.isEnabled = false
            self.initPlayerView()
            self.isFirstLaunch = false
            playBtn.isEnabled = true
            return
        }
        if !playerView.playing{
            self.avplayer.pause()
        }else{
            if self.avplayer.status == AVPlayerStatus.readyToPlay{
                self.avplayer.play()
            }
        }
    }
}
