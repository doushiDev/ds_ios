//
//  VideoTaxisTableViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/20.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

import Alamofire
import Kingfisher

import HandyJSON
import SwiftyJSON

class VideoTaxisTableViewController: UITableViewController {
    
    //视频集合
    
    var videos:[Video] = []
    //请求视频状态
    var populatingVideo = false
    
    
    let config = URLSessionConfiguration.default
    
    // 视频分类
    var type = 0
    
    var alertController: UIAlertController?
    
    
    var userId = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.title = "排行榜"
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")
        
        
        self.loadNewData()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        //        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    /**
     视图全部加载完 出现
     
     - parameter animated: animated description
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    // MARK: - Table view data source
    // 加载新数据
    func loadNewData(){
        
        Alamofire.request("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/0/30/33").responseJSON { response in
            
            
            switch response.result {
                
            case .success:
                
                if let JSONData = response.result.value {
                    if let videoList = JSONDeserializer<Video>.deserializeModelArrayFrom(json: JSON(JSONData)["content"].rawString()) {
                        
                        self.videos = videoList as! [Video]
                        self.tableView.reloadData()
                        
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
            
            
        }
        
    }
    //
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let aStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
    //
    //        let playVideoViewController = aStoryboard.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
    //
    //
    //        let url = URL(string: self.videos[indexPath.row].videoUrl)
    //        //
    //        playVideoViewController.videoUrl = url
    //        playVideoViewController.videoTitle = self.videos[indexPath.row].title
    //        playVideoViewController.videoUrlStr = self.videos[indexPath.row].videoUrl
    //        playVideoViewController.videoPic = self.videos[indexPath.row].pic
    //
    //        let cell = tableView.cellForRow(at: indexPath) as! HomeVideoTableViewCell
    //
    //        playVideoViewController.videoImage = cell.videoImageView
    //
    //        let video:RealmVideo = RealmVideo()
    //        video.vid = self.videos[indexPath.row].vid!
    //        video.videoUrl = self.videos[indexPath.row].videoUrl
    //        video.pic = self.videos[indexPath.row].pic!
    //        video.title = self.videos[indexPath.row].title!
    //        video.shareUrl = self.videos[indexPath.row].shareUrl
    //        video.at = self.videos[indexPath.row].at
    //        playVideoViewController.realmVideo = video
    //        if video.at != 1 {
    //
    //            //            return
    //
    //            MobClick.event("ads")
    //
    //            let evaluateString = self.videos[indexPath.row].videoUrl
    //
    //            UIApplication.shared.openURL(URL(string: evaluateString)!)
    //
    //        }else {
    //
    //            self.navigationController?.pushViewController(playVideoViewController, animated: true)
    //        }
    //
    //
    //
    //    }
    //
    
    
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
    
    
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // 播放页面隐藏tabbar
        //        if segue.identifier == "toPlayVideo" {
        
        let path = self.tableView.indexPathForSelectedRow!
        
        
        
        if let playVideoViewController = segue.destination as? PlayVideoViewController {
            
            
            let url = URL(string: self.videos[path.row].videoUrl)
            //
            playVideoViewController.videoUrl = url
            playVideoViewController.videoTitle = self.videos[path.row].title
            playVideoViewController.videoUrlStr = self.videos[path.row].videoUrl
            playVideoViewController.videoPic = self.videos[path.row].pic
            
            let cell = tableView.cellForRow(at: path) as! HomeVideoTableViewCell
            
            playVideoViewController.videoImage = cell.videoImageView
            
            let video:RealmVideo = RealmVideo()
            video.vid = self.videos[path.row].vid!
            video.videoUrl = self.videos[path.row].videoUrl
            video.pic = self.videos[path.row].pic!
            video.title = self.videos[path.row].title!
            video.shareUrl = self.videos[path.row].shareUrl
            video.at = self.videos[path.row].at
            playVideoViewController.realmVideo = video
            if video.at != 1 {
                
                //            return
                
                MobClick.event("ads")
                
                let evaluateString = self.videos[path.row].videoUrl
                
                UIApplication.shared.openURL(URL(string: evaluateString)!)
                
            }else {
                
                //                self.navigationController?.pushViewController(playVideoViewController, animated: true)
            }
        }
        //        }
    }
    
    
    
}
