//
//  UIViewController-Extension.swift
//  doushi-ios 扩展UIViewController
//
//  Created by Songlijun on 15/10/18.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    

    /**
    navigationController 设置参数
    */
    func setNav(){
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:"#f5f5f7")
        if let barFont = UIFont(name: "Helvetica Neue", size: 17.0) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(rgba:"#f0a22a"), NSFontAttributeName:barFont]
        }
    }
}