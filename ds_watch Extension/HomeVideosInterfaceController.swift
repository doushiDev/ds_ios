//
//  HomeVideosInterfaceController.swift
//  test1
//
//  Created by 宋立君 on 15/11/26.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import WatchKit
import Foundation
import HomeKit

import Alamofire
import SwiftyJSON



class HomeVideosInterfaceController: WKInterfaceController,HttpProtocol {
    
    
    @IBOutlet var videoTable: WKInterfaceTable!
    
    
    let data = ["甄嬛气死皇后","我要飞的更高","屌丝如何讨好女神","屌丝如何讨好女神","屌丝如何讨好女神","屌丝如何讨好女神"]
    
    var httpController:HttpController = HttpController()
    
    
//    var videoData = [VideoInfo(id: "1",title: "史上最坑法号！还有比这个更坑的吗？求解！",pic: "http://dlqncdn.miaopai.com/stream/W5uteYTTs4zO1-l3OEDjKA___m.jpg",url: "http:s//api.doushi.me/1.mp4",cTime:"ddd",isCollectStatus:0),
//        
//    VideoInfo(id: "7",title: "最吊大师",pic: "http://wsqncdn.miaopai.com/stream/2yvi2ufOtdHTvC1qmdUkWw___m.jpg",url: "https://api.doushi.me/1.mp4",cTime:"ddd",isCollectStatus:0),
//        
//    VideoInfo(id: "12",title: "假冒男朋友",pic: "http://qncdn.miaopai.com/imgs/iFt-KUOjcWrtFpBRbuTPxg___000001.jpg",url: "https://api.doushi.me/1.mp4",cTime:"ddd",isCollectStatus:0)
//    
//    ]
//    
    var videoData  = NSMutableOrderedSet()


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        
//        httpController.delegate = self
//        httpController.onGetVideoss(HttpClientByVideo.DSRouter.getVideoTaxis(1)) { (videoInfos) -> Void in
//            
//            print(videoInfos)
//            
//        }
        
        if context == nil {
        
        
        HttpController.onGetVideoss(HttpClientByVideo.DSRouter.getVideoTaxis(1)) {  videoInfos in
            
            
            print(videoInfos?.count)
            
            
            self.videoData.addObjectsFromArray(videoInfos!)
            
            self.videoTable.setNumberOfRows(videoInfos!.count, withRowType: "dsVideoType")
            
            for (index, value) in videoInfos!.enumerate() {
                
                let videoInfo = value as VideoInfo
                

                
                let controller = self.videoTable.rowControllerAtIndex(index) as! MainRowType
                controller.titleLabel.setText(videoInfo.title)
            }
            
            self
        }
        
        }
        
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print("点击了\(rowIndex)")
        
        if #available(watchOSApplicationExtension 20000, *) {
            let controller = videoTable.rowControllerAtIndex(rowIndex) as! HMAccessory
            self.pushControllerWithName("PlayVideoInterfaceController", context: controller)

        } else {
            // Fallback on earlier versions
        }
 

        
        self.dismissController()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return videoData[rowIndex]
    }
    
    func didRecieveResults(results: AnyObject) {
        
        print("data:\(results)")
        let json = JSON(results)
        
        print(json)
        //添加数据
        
//        videoTable.setNumberOfRows(videoData.count, withRowType: "dsVideoType")
//
//        for (index, value) in videoData.enumerate() {
//            
//            let videoInfo = value as! VideoInfo
//            
//            let controller = videoTable.rowControllerAtIndex(index) as! MainRowType
//            controller.titleLabel.setText(videoInfo.title)
//        }
        
    }
    
    


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
     

}
