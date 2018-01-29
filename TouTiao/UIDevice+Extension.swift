//
//  UIDevice+Extension.swift
//  TouTiao
//
//  Created by 宋立君 on 2018/1/29.
//  Copyright © 2018年 Songlijun. All rights reserved.
//

import Foundation


extension UIDevice {
    public static func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
