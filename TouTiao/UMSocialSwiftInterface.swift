//
//  UMSocialSwiftInterface.swift
//  UMSocialDemo
//
//  Created by 张军华 on 2017/1/20.
//  Copyright © 2017年 Umeng. All rights reserved.
//

import Foundation


class UMSocialSwiftInterface: NSObject {
    
    //swift的分享
    static func share(plattype:UMSocialPlatformType,
                      messageObject:UMSocialMessageObject,
                      viewController:UIViewController?,
                      completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
        UMSocialManager.default().share(to: plattype, messageObject: messageObject, currentViewController: viewController) { (shareResponse, error) in
            completion(shareResponse, error);
        }
    }
    
    //授权
    static func auth(plattype:UMSocialPlatformType,
                      viewController:UIViewController?,
                      completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
        UMSocialManager.default().auth(with: plattype, currentViewController: viewController) { (shareResponse, error) in
                completion(shareResponse, error);
        }
    }
    
    //取消授权
    static func cancelAuth(plattype:UMSocialPlatformType,
                     completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
        UMSocialManager.default().cancelAuth(with: plattype) { (shareResponse, error) in
            completion(shareResponse, error);
        }
    }
    
    //获得用户资料
    static func getUserInfo(plattype:UMSocialPlatformType,
                     viewController:UIViewController?,
                     completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
        UMSocialManager.default().getUserInfo(with: plattype, currentViewController: viewController) { (shareResponse, error) in
            completion(shareResponse, error);
        }
    }
    
    //弹出分享面板
    static func showShareMenuViewInWindowWithPlatformSelectionBlock(selectionBlock:@escaping (_ platformType:UMSocialPlatformType, _ userinfo:Any?) -> Void) -> Void {
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userinfo) in
            selectionBlock(platformType,userinfo);
        }
    }
    
    //设置预定义平台
    //备注:preDefinePlatforms为[NSNumber]的类型
    static func setPreDefinePlatforms(_ preDefinePlatforms: [Any]!) -> Void {
          //调用setPreDefinePlatforms的示例
        UMSocialUIManager.setPreDefinePlatforms(
            [NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue)
            ,NSNumber(integerLiteral:UMSocialPlatformType.QQ.rawValue)
            ,NSNumber(integerLiteral:UMSocialPlatformType.sina.rawValue)
            ]
        )
        UMSocialUIManager.setPreDefinePlatforms(preDefinePlatforms)
    }
}
