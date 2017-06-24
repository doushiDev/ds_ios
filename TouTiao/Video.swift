//
//  Video.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/25.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import Foundation
import HandyJSON


struct Video: HandyJSON {
    
    
    var vid:String?
    var title:String?
    var pic:String?
    var shareUrl:String = ""
    var videoUrl:String = ""
    var at:Int = 0

}
