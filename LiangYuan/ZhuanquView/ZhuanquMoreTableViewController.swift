//
//  ZhuanquMoreTableViewController.swift
//  LiangYuan
//
//  Created by SN on 2017/11/22.
//  Copyright © 2017年 Shengsiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZhuanquMoreTableViewController: UITableViewController {
    
    // MARK:- Properties
//    var titleArray = [String]()
    var subjectCode = 0
    var albumses = [AlbumsInfo](){
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.bounces = false
        self.tableView.register(ZhuanquMoreTableViewCell.self, forCellReuseIdentifier: ZhuanquMoreTableViewCell.reuseIdentifier)
        self.initData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - 从网络下载数据
    func initData() {
        
        //下载章节页数据
        let url = Network.Domain + "album/list/\(subjectCode)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let JSONData = response.result.value else { return }
            let json = JSON(JSONData)
            
            guard let albumsJSONArray = json["result"].array else {return}
            for albumsJSON in albumsJSONArray {
                let albums = AlbumsInfo(albumJSON: albumsJSON)
                self.albumses.append(albums)
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumses.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZhuanquMoreTableViewCell.reuseIdentifier, for: indexPath) as! ZhuanquMoreTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let albums = albumses[indexPath.row]
        cell.title = albums.title
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ZhuanquMoreTableViewCell.getCellHeight()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albums = albumses[indexPath.row]
        if let mp3URL = albums.fileUrl {
            if mp3URL != "" {
                performSegue(withIdentifier: Constants.ToChapterDetailSegue, sender: (albums.albumCode, DownloadType.albums))
                return
            }
        }
        performSegue(withIdentifier: Constants.ToAlbumsDetailSegue, sender: albums.albumCode)

    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? ZhuanquDetailViewController, let id = sender as? Int, segue.identifier == Constants.ToAlbumsDetailSegue {
            destination.albumsInfo = AlbumsInfo(albumCode: id)
            destination.hidesBottomBarWhenPushed = true
        }
        if let destination = segue.destination as? ChapterViewController, let (id, type) = sender as? (Int , DownloadType), segue.identifier == Constants.ToChapterDetailSegue {
            destination.code = id
            destination.downloadType = type
            destination.hidesBottomBarWhenPushed = true
        }
    }
    
}

