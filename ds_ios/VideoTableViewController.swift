//
//  NewVideoTableViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/10/27.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import Kingfisher

class VideoTableViewController: UITableViewController {
    
    @IBOutlet var otherView: UIView!
    
    //加载超时操作
    var ti:NSTimer?
    
    
    
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
    let user =  userDefaults.objectForKey("userInfo")
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        otherView.frame = CGRectMake(0.0, (self.view.frame.maxY - 220) / 2, self.view.frame.width, 100)
        otherView.hidden = true
        self.view.addSubview(otherView)
        
        //调整tableview frame
        //        print(self.view.frame)
        
        self.view.frame = CGRectMake(0, 64, self.tableView.frame.width, self.tableView.frame.height)
        
        //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewData()
            
        })
        self.tableView.mj_header.beginRefreshing()
        //
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData()
            
        })
        self.tableView.mj_footer.hidden = true
        
        
        ti = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        
        //注册3DTouch
        registerForPreviewingWithDelegate(self, sourceView: view)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func restartData(sender: AnyObject) {
        ti = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        self.tableView.mj_header.beginRefreshing()
        self.loadNewData()
        
        otherView.hidden = true
        
        
    }
    
    
    func restartData() {
        ti = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(VideoTableViewController.isLoading), userInfo: "isLoading", repeats: true)
        
        self.tableView.mj_header.beginRefreshing()
        self.loadNewData()
        
        otherView.hidden = true
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
                otherView.hidden = false
            }
        }else{
            self.tableView.mj_footer.endRefreshing()
            otherView.hidden = true
        }
        //停止
        ti?.invalidate()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏scroll indicators
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        //判断用户缓存中是否存在
        if (user != nil) {
            userId = user!.objectForKey("id") as! Int
            
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
        
        HttpController.getVideos(HttpClientByVideo.DSRouter.VideosByType(0, 20,type,DataCenter.shareDataCenter.user.id)) { videoInfos  in
            
            if videoInfos != nil {
                
                self.otherView.hidden = true
                
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
                    self.otherView.hidden = false
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
        
        HttpController.getVideos(HttpClientByVideo.DSRouter.VideosByType(self.currentPage, 20,type,DataCenter.shareDataCenter.user.id)) { videoInfos  in
            
            if videoInfos != nil {
                
                self.otherView.hidden = true
                
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
                    self.otherView.hidden = false
                }
            }
            
        }
        
        self.populatingVideo = false
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.videoInfos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoTableViewCell", forIndexPath: indexPath) as! VideoTableViewCell
        
        if self.videoInfos.count > 0 {
            
            let videoInfo = self.videoInfos[indexPath.row]
            
            cell.titleLabel.text = videoInfo.title
            cell.timeLabel.text = videoInfo.cTime
            cell.picImageView.kf_setImageWithURL(NSURL(string: videoInfo.pic)!)
            
        }
        return cell
    }
    
    
    override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // 滑动显示scroll indicators
        self.tableView.showsHorizontalScrollIndicator = true
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPlayVideo" {
            
            let path = self.tableView.indexPathForSelectedRow!
            let videoInfo = self.videoInfos[path.row]
            
            DataCenter.shareDataCenter.videoInfo = videoInfo
            
            
            //            let playVideoViewController =  segue.destinationViewController as! PlayVideoViewController
            
        }
    } 
    
}

