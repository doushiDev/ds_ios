//
//  DataCenter.swift
//  ds_ios
//
//  Created by 宋立君 on 15/12/1.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import Foundation


/// 数据中心
class DataCenter: NSObject {
    
    private static var __once: () = { () -> Void in
            Static.instance = DataCenter()
        }()
    
    //单例
    class var shareDataCenter:DataCenter{
        struct Static {
            static var onceToken : Int = 0
            static var instance: DataCenter? = nil
        }
        
        _ = DataCenter.__once
        return Static.instance!
    }
    
    
    //用户信息
    var user:User = User()
    
    
    func getVideosFromType(_ type:Int) -> [VideoInfo]{
        
        switch type{
        case 0:
            return videoInfos
        case 1:
            return videoInfosFromHot
        case 2:
            return videoInfosFromPop
        default:
            return []
        }
    }
     
    //视频集合推荐
    var videoInfos:[VideoInfo] = [VideoInfo]()
    
    //视频集合热门
    var videoInfosFromHot:[VideoInfo] = [VideoInfo]()
    
    
    //视频集合精华
    var videoInfosFromPop:[VideoInfo] = [VideoInfo]()
    
    
    //视频信息
    var videoInfo:VideoInfo = VideoInfo()
    
    struct paramModel {
        var videoUrlString = ""
        var videoTitleLabel = ""
        var videoInfoLable = ""
        var videoPic = ""
        var videoId = ""
    }
    
    
    
}
