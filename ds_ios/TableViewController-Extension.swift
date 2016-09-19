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
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        // Get indexPath for location (CGPoint) + cell (for sourceRect)
        guard let indexPath = tableView.indexPathForRow(at: location),
            let _ = tableView.cellForRow(at: indexPath) else { return nil }
        
        // Instantiate VC with Identifier (Storyboard ID)
        guard let playVideoViewController = storyboard?.instantiateViewController(withIdentifier: "playVideoView") as? PlayVideoViewController else { return nil }
        
        let videoInfo = self.videoInfos[(indexPath as NSIndexPath).row]
        
        DataCenter.shareDataCenter.videoInfo = videoInfo

//        playVideoViewController.videoUrlString = videoInfo.url
//        playVideoViewController.videoTitleLabel =  videoInfo.title
//        playVideoViewController.videoInfoLable = videoInfo.title
//        playVideoViewController.isCollectStatus = videoInfo.isCollectStatus
        playVideoViewController.userId = userId
//        playVideoViewController.videoId = videoInfo.id
//        playVideoViewController.videoPic = videoInfo.pic

        let cellFrame = tableView.cellForRow(at: indexPath)!.frame
        
        previewingContext.sourceRect = view.convert(cellFrame, from: tableView)
        
        return playVideoViewController
    }
    
    
    /**
     重按进入视频播放
     
     - parameter previewingContext:      previewingContext description
     - parameter viewControllerToCommit: viewControllerToCommit description
     */
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
        
    }
    
    
    /**
     检测页面是否处于3DTouch
     */
    func check3DTouch(){
        
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            
            self.registerForPreviewing(with: self, sourceView: self.view)
            print("3D Touch 开启")
            //长按停止
            UILongPressGestureRecognizer().isEnabled = false
            
        } else {
            print("3D Touch 没有开启")
            UILongPressGestureRecognizer().isEnabled = true
        }
    }
    
     
   
}





