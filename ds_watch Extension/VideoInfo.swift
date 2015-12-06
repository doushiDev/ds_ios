//
//  VideoInfo.swift
//  test1
//
//  Created by 宋立君 on 15/11/26.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import Foundation

class VideoInfo {
    let id: String
    let title: String
    let pic: String
    let url: String
    let cTime: String
    let isCollectStatus:Int
    
    init(id: String, title: String,pic: String,url: String,cTime: String,isCollectStatus:Int) {
        self.id = id
        self.title = title
        self.pic = pic
        self.url = url
        self.cTime = cTime
        self.isCollectStatus = isCollectStatus
    }

}
