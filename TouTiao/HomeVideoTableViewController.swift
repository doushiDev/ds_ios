//
//  HomeVideoTableViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/25.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import HandyJSON
import SwiftyJSON
import APParallaxHeader
import SDCycleScrollView


class HomeVideoTableViewController: UITableViewController,SDCycleScrollViewDelegate,APParallaxViewDelegate {
    
    var cid:Int = 0
    
    var videos:[Video] = []
    
    
    //视频集合
    var videos1:[Video] = []
    
    
    //图片地址集合
    let imageURL = [ "http://mvimg2.meitudata.com/5626e665370cc6772.jpg!thumb320",
                     "http://mvimg2.meitudata.com/562602616fc839554.jpg!thumb320",
                     "http://mvimg2.meitudata.com/56234c04a53038517.jpg!thumb320"
    ]
    var imageURL1 = [String]()
    var titles1 = [String]()
    
    let titles  = ["偏偏起舞的青春","小苹果 疯狂🎸","hey 逗比"]
    
    var tableHeardView = SDCycleScrollView()
    
    
    
    // 起始页码
    var pageNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")

        //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.pageNum = 0
            self.loadData(cid: 0, pageNum: self.pageNum, count: 30)
            
        })
        self.tableView.mj_header.beginRefreshing()
        //
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadData(cid: 0, pageNum: self.pageNum, count: 30)
            
        })
        self.tableView.mj_footer.isHidden = true
        
        loadData1()
        tableHeardView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        
        
        tableHeardView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        tableHeardView.delegate = self;
        
        
        tableHeardView.pageDotColor = Color.yellow// 自定义分页控件小圆标颜色
        tableHeardView.placeholderImage = UIImage(named: "tutorial_background_03")
        tableHeardView.autoScrollTimeInterval = 5
        tableHeardView.showPageControl = false
        
        
        self.tableView.addParallax(with: tableHeardView, andHeight: 200)
        self.tableView.parallaxView.delegate = self
        
        
        
        
    }
    
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        //        print("点击了\(index) 张图片")
        let videoInfo = (self.videos[index] )
        
        
        
        let aStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        
        let playVideoViewController = aStoryboard.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
        
        let video:RealmVideo = RealmVideo()
        video.vid = videoInfo.vid!
        video.videoUrl = videoInfo.videoUrl
        video.pic = videoInfo.pic!
        video.title = videoInfo.title!
        video.shareUrl = videoInfo.shareUrl
        video.at = videoInfo.at
        playVideoViewController.realmVideo = video
        
        let url = URL(string: self.videos1[index].videoUrl)
        //
        playVideoViewController.videoUrl = url
        playVideoViewController.videoTitle = videoInfo.title
        playVideoViewController.videoUrlStr = videoInfo.videoUrl
        playVideoViewController.videoPic = videoInfo.pic
        
        
        if videoInfo.at != 1 {
            
            //            return
            
            MobClick.event("ads")
            
            let evaluateString = self.videos1[index].videoUrl
            
            UIApplication.shared.openURL(URL(string: evaluateString)!)
            
        }else {
            
            self.navigationController?.pushViewController(playVideoViewController, animated: true)
        }
        
        
        
        
        
    }
    
    
    
    
    func loadData1(){
        
        
        Alamofire.request("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/0/30/33").responseJSON { response in
            
            
            switch response.result {
                
            case .success:
                
                if let JSONData = response.result.value {
                    if let videoList = JSONDeserializer<Video>.deserializeModelArrayFrom(json: JSON(JSONData)["content"].rawString()) {
                        
                        
                        
                        self.imageURL1.removeAll()
                        self.titles1.removeAll()
                        self.videos.removeAll()
                        self.videos1 = videoList as! [Video]
                        
                        for index in 0...4 {
                            let videoInfo = (self.videos1[index] )
                            
                            self.imageURL1.append(videoInfo.pic!)
                            self.titles1.append(videoInfo.title!)
                            
                        }
                        
                        
                        self.tableHeardView.titlesGroup = self.titles1;
                        self.tableHeardView.imageURLStringsGroup = self.imageURL1
                        
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
            
            
        }
        
        
    }
    
    func parallaxView(_ view: APParallaxView!, willChangeFrame frame: CGRect) {
        
    }
    
    func parallaxView(_ view: APParallaxView!, didChangeFrame frame: CGRect) {
        
    }
    
    
    func loadData(cid:Int, pageNum:Int, count:Int) {
        
        
//        print(self.view.tag)
        
//        print("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/\(pageNum)/\(count)/\(self.view.tag)")
        
        Alamofire.request("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/\(pageNum)/\(count)/\(self.view.tag)").responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let JSONData = response.result.value {
                    if let videoList = JSONDeserializer<Video>.deserializeModelArrayFrom(json: JSON(JSONData)["content"].rawString()) {
                        
                        if pageNum == 0{
                            self.videos = videoList as! [Video]
                            self.tableView.mj_header.endRefreshing()
                            
                        }else{
                            var dictInts = Dictionary<String, Video>()
                            
                            
                            
                            for number in videoList {
                                //                            if number.at == 1 {
                                dictInts[(number?.vid!)!] = number
                                //                            }
                            }
                            
                            var result = [Video]()
                            for value in dictInts.values {
                                result.append(value)
                            }
                            self.videos = self.videos + result
                            if videoList.count == 0 {
                                
                                self.tableView?.mj_footer.endRefreshingWithNoMoreData()
                            }else {
                                self.tableView?.mj_footer.endRefreshing()

                            }
                            
                        }
                        
                        self.pageNum = self.pageNum + 1
                        self.tableView.reloadData()
                        
                    }
                }
                
            case .failure(let error):
                self.tableView.mj_header.endRefreshing()
                self.tableView?.mj_footer.endRefreshing()
                print(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView?.mj_footer.isHidden = self.videos.count == 0;
        return self.videos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoTableViewCell", for: indexPath) as! HomeVideoTableViewCell
        
        // Configure the cell...
        
        let url = URL(string: videos[indexPath.row].pic!)
        
        cell.videoImageView.kf.setImage(with: url, placeholder: Image(named:"moren"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        
        
        cell.videoTitleLabel.text = videos[indexPath.row].title
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        print("回到首页")
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        
        let playVideoViewController = aStoryboard.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
        
        if videos.count > 0 {
            let url = URL(string: self.videos[indexPath.row].videoUrl)
            //
            playVideoViewController.videoUrl = url
            playVideoViewController.videoTitle = self.videos[indexPath.row].title
            playVideoViewController.videoUrlStr = self.videos[indexPath.row].videoUrl
            playVideoViewController.videoPic = self.videos[indexPath.row].pic
            
            let cell = tableView.cellForRow(at: indexPath) as! HomeVideoTableViewCell
            
            playVideoViewController.videoImage = cell.videoImageView
            
            let video:RealmVideo = RealmVideo()
            video.vid = self.videos[indexPath.row].vid!
            video.videoUrl = self.videos[indexPath.row].videoUrl
            video.pic = self.videos[indexPath.row].pic!
            video.title = self.videos[indexPath.row].title!
            video.shareUrl = self.videos[indexPath.row].shareUrl
            video.at = self.videos[indexPath.row].at
            playVideoViewController.realmVideo = video
            if video.at != 1 {
                
                //            return
                
                MobClick.event("ads")
                
                let evaluateString = self.videos[indexPath.row].videoUrl
                
                UIApplication.shared.openURL(URL(string: evaluateString)!)
                
            }else {
                
                self.navigationController?.pushViewController(playVideoViewController, animated: true)
            }
            

        }
        
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //
    //        if segue.identifier == "playVideo" {
    //
    //            let videoViewController = segue.destination as! PlayVideoViewController
    //
    //            let cell = sender as! HomeVideoTableViewCell
    //            let indexPath = self.tableView.indexPath(for: cell)
    //
    //
    //            self.tableView.deselectRow(at: indexPath!, animated: true)
    //
    //            if self.videos[indexPath!.row].at != 1 {
    //
    //                //            return
    //
    //            }
    //
    //            let url = URL(string: self.videos[indexPath!.row].videoUrl)
    //
    //            videoViewController.videoUrl = url
    //            videoViewController.videoTitle = self.videos[indexPath!.row].title
    //
    //            let video:RealmVideo = RealmVideo()
    //            video.vid = self.videos[indexPath!.row].vid!
    //            video.videoUrl = self.videos[indexPath!.row].videoUrl
    //            video.pic = self.videos[indexPath!.row].pic!
    //            video.title = self.videos[indexPath!.row].title!
    //            video.shareUrl = self.videos[indexPath!.row].shareUrl
    //            video.at = self.videos[indexPath!.row].at
    //            videoViewController.realmVideo = video
    //
    //        }
    //
    //
    //    }
    
    
}
