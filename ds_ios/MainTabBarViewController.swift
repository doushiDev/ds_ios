//
//  MainTabBarViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/10/31.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITabBar delegate 实现双击tabBar刷新
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
//        print("self.selectedIndex-> \(self.selectedIndex)")
//        print("item.tag-> \(item.tag)")

//        
         if (self.selectedIndex == 1 && self.selectedIndex == item.tag ) {
//            print("双击了\(item.tag)")

        }
        self.selectedIndex = item.tag;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
