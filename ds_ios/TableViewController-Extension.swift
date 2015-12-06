//
//  TableViewController-Extension.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/17.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import Foundation

import UIKit


extension VideoTableViewController: UIViewControllerPreviewingDelegate{
    
    
    // MARK: 3D Touch Delegate
    
    /**
    轻按进入浮动页面
    
    - parameter previewingContext: previewingContext description
    - parameter location:          location description
    
    - returns: 文章详情页  浮动页
    */
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        // Get indexPath for location (CGPoint) + cell (for sourceRect)
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            _ = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        // Instantiate VC with Identifier (Storyboard ID)
        guard let playVideoViewController = storyboard?.instantiateViewControllerWithIdentifier("playVideoView") as? PlayVideoViewController else { return nil }
        
        let videoInfo = self.videoInfos[indexPath.row]
        
        DataCenter.shareDataCenter.videoInfo = videoInfo

//        playVideoViewController.videoUrlString = videoInfo.url
//        playVideoViewController.videoTitleLabel =  videoInfo.title
//        playVideoViewController.videoInfoLable = videoInfo.title
//        playVideoViewController.isCollectStatus = videoInfo.isCollectStatus
        playVideoViewController.userId = userId
//        playVideoViewController.videoId = videoInfo.id
//        playVideoViewController.videoPic = videoInfo.pic

        let cellFrame = tableView.cellForRowAtIndexPath(indexPath)!.frame
        
        previewingContext.sourceRect = view.convertRect(cellFrame, fromView: tableView)
        
        return playVideoViewController
    }
    
    
    /**
     重按进入视频播放
     
     - parameter previewingContext:      previewingContext description
     - parameter viewControllerToCommit: viewControllerToCommit description
     */
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
        
    }
    
    
    /**
     检测页面是否处于3DTouch
     */
    func check3DTouch(){
        
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
            print("3D Touch 开启")
            //长按停止
            UILongPressGestureRecognizer().enabled = false
            
        } else {
            print("3D Touch 没有开启")
            UILongPressGestureRecognizer().enabled = true
        }
    }
    
     
   
}





