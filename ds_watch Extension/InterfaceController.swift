//
//  InterfaceController.swift
//  ds_watch Extension
//
//  Created by 宋立君 on 15/11/27.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON

class InterfaceController: WKInterfaceController,HttpProtocol {
    
    //网络控制器的类的实例
    var httpController:HttpController = HttpController()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
////        httpController.delegate = self
//        httpController.onGetVideos(URLRequestConvertible) { ([VideoInfo]?) -> Void in
//            <#code#>
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
    
    
    
    func didRecieveResults(results: AnyObject) {
        
        print("data:\(results)")
        let json = JSON(results)
        
        print(json)
    }
    
 
}
