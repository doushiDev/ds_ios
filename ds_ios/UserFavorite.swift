//
//  UserFavorite.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/18.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

//用户收藏类

class UserFavorite : NSObject{
 
    
    let id: Int
    let userId: Int
    let videoId: String
    let status: Int
    
    init(id: Int, userId: Int,videoId: String,status:Int) {
        self.id = id
        self.userId = userId
        self.videoId = videoId
        self.status =  status
    }

}
