//
//  VideoTaxisTableViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/20.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

import Alamofire
import MJRefresh
import Kingfisher

class VideoTaxisTableViewController: UITableViewController {

    //视频集合
    var videos  = NSMutableOrderedSet()
    
    //请求视频状态
    var populatingVideo = false
    
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    // 视频分类
    var type = 0
    
    var alertController: UIAlertController?
    
    
    var userId = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.title = "排行榜"
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")
        
        setNav()
        
        //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewData()
            
        })
        
        self.tableView.mj_header.beginRefreshing()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.hidden = false

     }
    
    /**
     视图全部加载完 出现
     
     - parameter animated: animated description
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated) 
        
        
    }

    let user =  userDefaults.objectForKey("userInfo")

    
    // MARK: - Table view data source
    // 加载新数据
    func loadNewData(){
        
        if populatingVideo {
            return
        }
        populatingVideo = true
        
        if (user != nil) {
            userId = user!.objectForKey("id") as! Int
            
        }
        
        HttpController.getVideos(HttpClientByVideo.DSRouter.getVideoTaxis(userId)) { videoInfos in
            
            if videoInfos != nil {
                self.videos.addObjectsFromArray(videoInfos!)
                self.tableView.reloadData()

            }
            self.tableView.mj_header.endRefreshing()
            self.populatingVideo = false
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoTableViewCell", forIndexPath: indexPath) as! VideoTableViewCell
        
        if videos.count > 0 {
            let videoInfo = (videos.objectAtIndex(indexPath.row) as! VideoInfo)
            
            cell.titleLabel.text = videoInfo.title
            cell.picImageView.kf_setImageWithURL(NSURL(string: videoInfo.pic)!)
            
        }
        
        
        return cell
    }
    
    
    
    override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // 播放页面隐藏tabbar
        if segue.identifier == "toPlayVideo" {
            
            let path = self.tableView.indexPathForSelectedRow!
            let videoInfo = (videos.objectAtIndex(path.row) as! VideoInfo)
            
            DataCenter.shareDataCenter.videoInfo = videoInfo

            let playVideoViewController =  segue.destinationViewController as! PlayVideoViewController
            playVideoViewController.userId = userId 
        }
    }
    


}
