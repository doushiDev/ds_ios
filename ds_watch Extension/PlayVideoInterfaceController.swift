//
//  PlayVideoInterfaceController.swift
//  test1
//
//  Created by 宋立君 on 15/11/26.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import WatchKit
import Foundation
import HomeKit


 @available(watchOSApplicationExtension 20000, *)
 class PlayVideoInterfaceController: WKInterfaceController,HMAccessoryDelegate {
    @IBOutlet var playVideo: WKInterfaceMovie!
    
    
    var mainRowType: HMAccessory!
    
    var videoInfo:VideoInfo!
    
    var video:NSURL!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        print(context)
        
        videoInfo = context as! VideoInfo
        
        print("URL -> \(videoInfo.url)")
 
        self.setTitle(videoInfo.title)
        
        video = NSURL(string: videoInfo.url)!

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        playVideo.setMovieURL(video)
        
        playVideo.setPosterImage(WKImage(imageName: "dd"))

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
