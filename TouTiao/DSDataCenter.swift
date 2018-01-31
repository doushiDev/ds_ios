//
//  DSDataCenter.swift
//  TouTiao
//
//  Created by 宋立君 on 2018/1/30.
//  Copyright © 2018年 Songlijun. All rights reserved.
//

import Foundation

/// 数据中心
class DSDataCenter {
    
    static let sharedInstance : DSDataCenter = {
        let instance = DSDataCenter()
        return instance
    }()
    
    //用户信息
    var user:User = User()
}

