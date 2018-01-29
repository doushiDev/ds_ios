//
//  FindMainTableViewController.swift
//  ds-ios
//
//  Created by Songlijun on 15/10/21.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import SDCycleScrollView
//import VGParallaxHeader
import APParallaxHeader
import Alamofire
import Kingfisher

import HandyJSON
import SwiftyJSON


class FindMainTableViewController: UITableViewController,SDCycleScrollViewDelegate,APParallaxViewDelegate {
    
    
    //视频集合
    var videos:[Video] = []
    
    
    //图片地址集合
    let imageURL = [ "http://mvimg2.meitudata.com/5626e665370cc6772.jpg!thumb320",
                     "http://mvimg2.meitudata.com/562602616fc839554.jpg!thumb320",
                     "http://mvimg2.meitudata.com/56234c04a53038517.jpg!thumb320"
    ]
    var imageURL1 = [String]()
    var titles1 = [String]()
    
    let titles  = ["偏偏起舞的青春","小苹果 疯狂🎸","hey 逗比"]
    
    var tableHeardView = SDCycleScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadData()
        
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")
        
        
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
    
    var userId = 0
    
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
            
            let url = URL(string: self.videos[index].videoUrl)
            //
            playVideoViewController.videoUrl = url
            playVideoViewController.videoTitle = videoInfo.title
            playVideoViewController.videoUrlStr = videoInfo.videoUrl
            playVideoViewController.videoPic = videoInfo.pic
            
            
            if videoInfo.at != 1 {
                
                //            return
                
                MobClick.event("ads")
                
                let evaluateString = self.videos[index].videoUrl
                
                UIApplication.shared.openURL(URL(string: evaluateString)!)
                
            }else {
                
                self.navigationController?.pushViewController(playVideoViewController, animated: true)
            }
            

            
            
    
        }
    
    
    
    
    func loadData(){
        
        
        Alamofire.request("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/0/30/33").responseJSON { response in
            
            
            switch response.result {
                
            case .success:
                
                if let JSONData = response.result.value {
                    if let videoList = JSONDeserializer<Video>.deserializeModelArrayFrom(json: JSON(JSONData)["content"].rawString()) {
                        
                        
                        
                        self.imageURL1.removeAll()
                        self.titles1.removeAll()
                        self.videos.removeAll()
                       self.videos = videoList as! [Video]
                        
                        for index in 0...4 {
                            let videoInfo = (self.videos[index] )
                            
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
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findTableCell", for: indexPath) as! FindTableViewCell
        
        cell.titleLabel.textColor = UIColor(rgba:"#f0a22a")
        
        if (indexPath as NSIndexPath).row == 0 {
            cell.titleLabel.text = "排行榜"
            cell.cellImageView.image =  UIImage(named: "sort")
        }
        
//        if (indexPath as NSIndexPath).row == 1 {
//            cell.titleLabel.text = "商品推广"
//            cell.cellImageView.image =  UIImage(named: "store")
//            
//        }
        
        
        //分割线
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadData()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        ViewControllerOne *oneController = [[self storyboard]instantiateViewControllerWithIdentifier:@"ViewOne"];
        
        
        
        if (indexPath as NSIndexPath).row == 0 {
            let videoTaxisTableViewController =  self.storyboard?.instantiateViewController(withIdentifier: "VideoTaxisTableViewController")
            videoTaxisTableViewController!.title = "排行榜"
            
            self.navigationController?.pushViewController(videoTaxisTableViewController!, animated: true)
            
        }
        
        if (indexPath as NSIndexPath).row == 1 {
            //            performSegueWithIdentifier("toAds", sender: self)
            
            let videoAdsTableViewController =  self.storyboard?.instantiateViewController(withIdentifier: "AdsTableViewController")
            videoAdsTableViewController!.title = "商品推广"
            
            self.navigationController?.pushViewController(videoAdsTableViewController!, animated: true)
            
        }
        
        
    }
    ;
    /*
     // MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
    }
    
    
}
