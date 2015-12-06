//
//  HttpController.swift
//  ds_ios
//
//  Created by 宋立君 on 15/11/27.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import WatchKit
import Alamofire

class HttpController: NSObject {
    
    //定义一个代理
    var delegate:HttpProtocol?
    //定义一个方法，接收网址，请求数据，回调代理的方法，传回数据
    func onGetVideos(urlRequestConvertible:URLRequestConvertible, callback:[VideoInfo]?->Void ){
        Alamofire.request(urlRequestConvertible).responseJSON { response in
            if let JSON = response.result.value {
                
                
                let videoInfos:[AnyObject];
                
                videoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { VideoInfo(id: $0["id"] as! String,title: $0["title"] as! String,pic: $0["pic"] as! String,url: $0["videoUrl"] as! String,cTime: $0["pushTime"] as! String,isCollectStatus: $0["isCollectStatus"] as! Int)}
                
                
                self.delegate?.didRecieveResults(videoInfos)
                 
            }
        }
    }
    
   class func onGetVideoss(urlRequestConvertible:URLRequestConvertible, callback:[VideoInfo]?->Void ){
        Alamofire.request(urlRequestConvertible).responseJSON { response in
            if let JSON = response.result.value {
                
                
                let videoInfos:[VideoInfo];
                
                videoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { VideoInfo(id: $0["id"] as! String,title: $0["title"] as! String,pic: $0["pic"] as! String,url: $0["videoUrl"] as! String,cTime: $0["pushTime"] as! String,isCollectStatus: $0["isCollectStatus"] as! Int)}
                
                
//                self.delegate?.didRecieveResults(videoInfos)
                callback(videoInfos)
            }
        }
    }
    
    

}

//定义http协议
protocol HttpProtocol{
    //定义一个方法，接收一个参数：AnyObject
    func didRecieveResults(results:AnyObject)
}


// 创建HttpClient结构体
struct HttpClientByVideo {
    
    // 创建逗视网络请求 Alamofire 路由
    enum DSRouter: URLRequestConvertible {
        
        // 逗视API地址
        static let baseURLString = "https://api.doushi.me/v1/rest/video/"
        
        // 请求方法
        case VideosByType(Int,Int,Int,Int) //根据类型获取视频
        case getVideosByBanner(Int) //获取发现Banner视频
        case getVideoTaxis(Int) //获取排行榜
        case getVideosById(String,Int) //根据视频id获取视频信息
        
        // 不同请求，对应不同请求类型
        var method: Alamofire.Method {
            switch self {
            case .VideosByType:
                return .GET
            case .getVideosByBanner:
                return .GET
            case .getVideoTaxis:
                return .GET
            case .getVideosById:
                return .GET
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            
            let (path) : (String) = {
                
                switch self {
                case .VideosByType(let vid, let count, let type,let userId):
                    return ("getVideosByType/\(vid)/\(count)/\(type)/\(userId)")
                case .getVideosByBanner(let userId):
                    return "getVideosByBanner/\(userId)"
                case .getVideoTaxis(let userId):
                    return "getVideoTaxis/\(userId)"
                case .getVideosById(let videoId,let userId):
                    return "getVideosById/\(videoId)/\(userId)"
                }
            }()
            
            let URL = NSURL(string: DSRouter.baseURLString)
            let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
             URLRequest.HTTPMethod = method.rawValue
            let encoding = Alamofire.ParameterEncoding.URL
            return encoding.encode(URLRequest, parameters: nil).0
        }
    }
}





