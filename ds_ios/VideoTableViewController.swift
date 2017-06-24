//
//  NewVideoTableViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/10/27.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
//import Alamofire
import MJRefresh
import Kingfisher

class VideoTableViewController: UITableViewController {
    
    @IBOutlet var otherView: UIView!
    
    //加载超时操作
    var ti:Timer?
    
    
    
    //视频集合
    var videos  = NSMutableOrderedSet()
    
    //请求视频状态
    var populatingVideo = false
    
    // 起始页码
    var currentPage = 0
    
    // 视频分类
    var type = 0
    
    var alertController: UIAlertController?
    
    
    var videoInfos:[VideoInfo] = []
    
    //用户信息
    let user =  userDefaults.object(forKey: "userInfo")
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        otherView.frame = CGRect(x: 0.0, y: (self.view.frame.maxY - 220) / 2, width: self.view.frame.width, height: 100)
        otherView.isHidden = true
        self.view.addSubview(otherView)
        
        //调整tableview frame
        //        print(self.view.frame)
        
        self.view.frame = CGRect(x: 0, y: 64, width: self.tableView.frame.width, height: self.tableView.frame.height)
        
        //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewData()
            
        })
        self.tableView.mj_header.beginRefreshing()
        //
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData()
            
        })
        
        self.tableView.mj_footer.isHidden = false
        
        
        ti = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        
        //注册3DTouch
        registerForPreviewing(with: self, sourceView: view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func restartData(_ sender: AnyObject) {
        ti = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        self.tableView.mj_header.beginRefreshing()
        self.loadNewData()
        
        otherView.isHidden = true
        
        
    }
    
    
    func restartData() {
        ti = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        self.tableView.mj_header.beginRefreshing()
        self.loadNewData()
        
        otherView.isHidden = true
    }
    
    
    /**
     检测加载是否超时
     */
    func isLoading() {
        //判断上拉or下拉
        if self.tableView.mj_header.isRefreshing() {
            
            self.tableView.mj_header.endRefreshing()
            
            //            self.tableView.reloadData()
            if self.videos.count == 0{
                otherView.isHidden = false
            }
        }else{
            self.tableView.mj_footer.endRefreshing()
            otherView.isHidden = true
        }
        //停止
        ti?.invalidate()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏scroll indicators
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        //判断用户缓存中是否存在
        if (user != nil) {
            userId = (user! as AnyObject).object(forKey: "id") as! Int
            
        }
        //检测3D Touch
        //        check3DTouch()
    }
    
    // MARK: - Table view data source
    // 加载新数据
    func loadNewData(){
        self.currentPage = 0
        
        print("currentPage-> \(self.currentPage)")
        
        
        if populatingVideo {
            return
        }
        populatingVideo = true
        
        HttpController.getVideos(HttpClientByVideo.DSRouter.videosByType(0, 20,type,DataCenter.shareDataCenter.user.id)) { videoInfos  in
            
            if videoInfos != nil {
                
                self.otherView.isHidden = true
                
                self.videoInfos = videoInfos!
                
                
                if self.videoInfos.last == nil {
                    self.currentPage = 0
                    
                }else {
                    self.currentPage = Int( (self.videoInfos.last)!.id)!
                }
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                
            }else{
                self.tableView.mj_header.endRefreshing()
                //没有数据时显示
                if self.videoInfos.count == 0 {
                    self.otherView.isHidden = false
                }
                
            }
            
        }
        self.populatingVideo = false
        //停止计时
        self.ti?.invalidate()
    }
    
    
    
    /**
     上拉加载更多数据
     */
    func loadMoreData() {
        
        
        if populatingVideo {
            return
        }
        
        populatingVideo = true
        
        print("currentPage-> \(self.currentPage)")
        
        HttpController.getVideos(HttpClientByVideo.DSRouter.videosByType(self.currentPage, 20,type,DataCenter.shareDataCenter.user.id)) { videoInfos  in
            
            if videoInfos != nil {
                
                self.otherView.isHidden = true
                
                self.videoInfos += videoInfos!
                
                if self.videoInfos.last == nil {
                    self.currentPage = 0
                    
                }else {
                    self.currentPage = Int( (self.videoInfos.last)!.id)!
                }
                
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }else{
                
                self.tableView.mj_footer.endRefreshing()
                //没有数据时显示
                if self.videoInfos.count == 0 {
                    self.otherView.isHidden = false
                }
            }
            
        }
        
        self.populatingVideo = false
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.videoInfos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        
        if self.videoInfos.count > 0 {
            
            let videoInfo = self.videoInfos[(indexPath as NSIndexPath).row]
            
            cell.titleLabel.text = videoInfo.title
            cell.timeLabel.text = videoInfo.cTime
            cell.picImageView.kf_setImage(with: URL(string: videoInfo.pic)!)
                        
        }
        return cell
    }
    
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 滑动显示scroll indicators
        self.tableView.showsHorizontalScrollIndicator = true
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayVideo" {
            
            let path = self.tableView.indexPathForSelectedRow!
            let videoInfo = self.videoInfos[(path as NSIndexPath).row]
            
            DataCenter.shareDataCenter.videoInfo = videoInfo
            
            
            //            let playVideoViewController =  segue.destinationViewController as! PlayVideoViewController
            
        }
    }
}

