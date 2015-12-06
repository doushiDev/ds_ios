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
    
    //单例
    class var shareDataCenter:DataCenter{
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance: DataCenter? = nil
        }
        
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.instance = DataCenter()
        }
        return Static.instance!
    }
    
    
    //用户信息
    var user:User = User()
    
    
    func getVideosFromType(type:Int) -> [VideoInfo]{
        
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