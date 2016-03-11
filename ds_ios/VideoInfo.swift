//
//  VideoInfo.swift
//  ds-ios 视频model
//
//  Created by Songlijun on 15/10/5.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

class VideoInfo: NSObject {

//    id: "24581", //视频id
//    title: "绿色兵团一命通关之教学版，其实高手在民间~",//视频标题
//    pic: "http://ww4.sinaimg.cn/orj480/736f0c7ejw1ewkybfyemuj20ds08mmz2.jpg",//视频图片
//    url: "http://video.weibo.com/show?fid=1034:e4e4e4e4ad8e4e80842f38ace37be0d5",//视频地址
//    mp4_url: "http://us.sinaimg.cn/002aw5RCjx06VQx4gykU050d010000IJ0k01.m3u8?KID=unistore,video&Expires=1444033396&ssig=UeubudqBUT",
//    cTime: "今天 13:39",//发布时间
//    favo_num: "5",//分享条数
//    zan_num: "62"//赞条数

	let id: String
	let title: String
	let pic: String
	let url: String
	let cTime: String
	let isCollectStatus: Int

	init(id: String, title: String, pic: String, url: String, cTime: String, isCollectStatus: Int) {
		self.id = id
		self.title = title
		self.pic = pic
		self.url = url
		self.cTime = cTime
		self.isCollectStatus = isCollectStatus
	}

	override init() {
		self.id = ""
		self.title = ""
		self.pic = ""
		self.url = ""
		self.cTime = ""
		self.isCollectStatus = 0
	}
}
