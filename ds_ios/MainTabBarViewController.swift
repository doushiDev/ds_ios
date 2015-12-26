//
//  MainTabBarViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/10/31.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITabBar delegate 实现双击tabBar刷新
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        
////        print("self.selectedIndex-> \(self.selectedIndex)")
////        print("item.tag-> \(item.tag)")
//
////        
//         if (self.selectedIndex == 1 && self.selectedIndex == item.tag ) {
////            print("双击了\(item.tag)")
//
//        }
//        self.selectedIndex = item.tag;
//    }
    
    
    
//    -(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if (viewController.tabBarItem.tag==2) {
//    UINavigationController *navigation =(UINavigationController *)viewController;
//    NoticeTableViewController *notice=(NoticeTableViewController *)navigation.topViewController;
//    [notice refreshData];
//    }
//    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if (viewController.tabBarItem.tag==1) {
            let navigation = viewController as! UINavigationController
            
           let  homeViewController = navigation.topViewController as! VideoTableViewController
            homeViewController.viewDidLoad()
//            if  homeViewController.pageMenu?.currentPageIndex == 1 {
//                
//                let aStoryboard = UIStoryboard(name: "Home", bundle:NSBundle.mainBundle())
//                let newVideoTableViewController = aStoryboard.instantiateViewControllerWithIdentifier("VideoTableViewController") as! VideoTableViewController
//                 newVideoTableViewController.type = 0
//                 newVideoTableViewController.videoInfos =
//                    DataCenter.shareDataCenter.getVideosFromType(0)
//                newVideoTableViewController.tableView.mj_header.beginRefreshing()
////                newVideoTableViewController.viewDidLoad()
//                
//                
//            }
//            homeViewController.viewDidLoad()
        }
        
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
