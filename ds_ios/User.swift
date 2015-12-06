//
//  User.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/8.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

//User {
//    id (integer, optional),
//    nickName (string, optional),
//    password (string, optional),
//    headImage (string, optional),
//    phone (string, optional),
//    gender (integer, optional),
//    platformId (string, optional),
//    platformName (string, optional)
//}


class User:NSObject{
    
    
    var id:Int = 0
    var nickName:String = ""
    var password:String = ""
    var headImage:String = ""
    var phone:String = ""
    var gender:Int = 0
    var platformId:String = ""
    var platformName:String = ""
    //    var isCollectStatus = 0
    

    init(id:Int,nickName:String,password:String,headImage:String,phone:String,gender:Int,platformId:String,platformName:String){
        
        self.id = id
        self.nickName = nickName
        
        self.password = password
        self.headImage = headImage
        self.phone = phone
        self.gender = gender
        self.platformId = platformId
        self.platformName = platformName
        
    }
    
    override init(){
        super.init()
        self.id = 0
        self.nickName = ""
        
        self.password = ""
        self.headImage = ""
        self.phone = ""
        self.gender = 0
        self.platformId = ""
        self.platformName = ""
    }
}