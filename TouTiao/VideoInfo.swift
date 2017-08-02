//
//  VideoInfo.swift
//  ds-ios 视频model
//
//  Created by Songlijun on 15/10/5.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

import HandyJSON

struct VideoInfo: HandyJSON {
   
	var id: String?
	var title: String?
	var pic: String?
	var url: String?
	var cTime: String?
	var isCollectStatus: Int = 0

}
