//
//  ResponseEntity.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/18.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

/// 返回信息实体
class ResponseEntity {
    
    let message: String
    let content: AnyObject
    let request: String
    let statusCode: Int
    
    init(message: String, content: AnyObject,request: String,statusCode:Int) {
        self.message = message
        self.content = content
        self.request = request
        self.statusCode =  statusCode
    }
    
}