//
//  RealmVideo.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/26.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmVideo: Object {
    
    dynamic var vid:String  = ""
    dynamic var title:String  = ""
    dynamic var pic:String  = ""
    dynamic var shareUrl:String = ""
    dynamic var videoUrl:String = ""
    dynamic var createDate:String = ""
    dynamic var at:Int = 1
    
    override static func primaryKey() -> String? {
        return "vid"
    }

}


