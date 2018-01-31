//
//  User.swift
//  TouTiao
//
//  Created by 宋立君 on 2018/1/30.
//  Copyright © 2018年 Songlijun. All rights reserved.
//

import Foundation
import HandyJSON

struct User: HandyJSON {
    
    var id: Int?
    var nickName: String = ""
    var headImage: String = ""
    var phone: String = ""
    var gender: Int?
    var platformId: String = ""
    var platformName: String = ""
    var channel: String = ""
    var integral: Int = 0
    
    init() {
        
    }
}
