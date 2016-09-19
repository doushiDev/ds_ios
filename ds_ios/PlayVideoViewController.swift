//
//  PlayVideoViewController.swift
//  doushi-ios 视频播放页
//
//  Created by Songlijun on 15/10/12.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import AVKit
import Alamofire


class PlayVideoViewController: UIViewController {
    
    var userId = 0
    
    var isC = false
    
    var videoController = KrVideoPlayerController()
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.check3DTouch()
        
        if  DataCenter.shareDataCenter.user.id != 0{
            userId = DataCenter.shareDataCenter.user.id
        }
        
        addPageMenu()
        
        let url = URL(string: DataCenter.shareDataCenter.videoInfo.url)
        self.addVideoPlayerWithURL(url!)
        
        //判断用户是否收藏过
        HttpController.getVideoById(HttpClientByVideo.DSRouter.getVideosById(DataCenter.shareDataCenter.videoInfo.id, self.userId), callback: { videoInfo -> Void in
            if videoInfo?.isCollectStatus == 1{
                self.isC = true
                
            }
        })
    }
    
    //完全进入视图 才播放
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.videoController.play()
    }
    
    //离开视图暂停播放
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoController.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        if  DataCenter.shareDataCenter.user.id != 0{
            userId = DataCenter.shareDataCenter.user.id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     添加播放器
     - parameter url: 视频url
     */
    func addVideoPlayerWithURL(_ url: URL){
        
        
        self.videoController =  KrVideoPlayerController(frame: CGRect(x: 0, y: 20, width: width, height: width*(9.0/16.0)))
        
        let willBackOrientationPortrait:() -> Void = {
            self.pageMenu?.view.isHidden = false
        }
        
        let willChangeToFullscreenMode:() -> Void = {
            self.pageMenu?.view.isHidden = true
        }
        
        self.videoController.willBackOrientationPortrait = willBackOrientationPortrait
        self.videoController.willChangeToFullscreenMode = willChangeToFullscreenMode
        self.view.addSubview(self.videoController.view)
        self.videoController.contentURL = url
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.videoController.stop()
    }
    
    //添加分页视图
    func addPageMenu(){
        
        var controllerArray : [UIViewController] = []
        
        // Do any additional setup after loading the view.
        let aStoryboard = UIStoryboard(name: "Play", bundle:Bundle.main)
        
        let playVideoInfoViewController = aStoryboard.instantiateViewController(withIdentifier: "PlayVideoInfoViewController") as! PlayVideoInfoViewController
        
        
        
        controllerArray.append(playVideoInfoViewController)
        
        
        //        let playVideoRecommendTableViewController = aStoryboard.instantiateViewControllerWithIdentifier("PlayVideoRecommendTableViewController") as! PlayVideoRecommendTableViewController
        //
        
        //相关推荐
        //        controllerArray.append(playVideoRecommendTableViewController)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(UIColor(rgba:"#f0a22a")),
            .unselectedMenuItemLabelColor(UIColor(rgba:"#939395")),
            .scrollMenuBackgroundColor(UIColor(rgba: "#f2f2f2")),
            .viewBackgroundColor(UIColor(rgba:"#e6e7ec")),
            .selectionIndicatorColor(UIColor(rgba:"#fea113")),
            .bottomMenuHairlineColor(UIColor(rgba:"#f5f5f7")),
            
            .menuItemFont(UIFont(name: "ChalkboardSE-Light", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: width*(9.0/16.0)+20, width: self.view.frame.width, height: self.view.frame.height -  width*(9.0/16.0) - 20), pageMenuOptions: parameters)
        
        print("pageMenu frame -> \( pageMenu?.view.frame)")
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    
    /**
     检测3D Touch
     */
    func check3DTouch() {
        if self.traitCollection.forceTouchCapability != UIForceTouchCapability.available {
            let tap = UITapGestureRecognizer(target: self, action: "dismissMe:")
            self.view.addGestureRecognizer(tap)
        }
    }
    
    var detailTitle: String?
    
    func dismissMe(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Preview action items.
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                
                
                if "收藏" == title {
                    print("点击了收藏 ->3D Touch")
                    self.collectVideo()
                }
                
                if "QQ" == title {
                    print("点击了QQ分享 ->3D Touch")
                }
                
                guard let detailViewController = viewController as? PlayVideoViewController,
                    let item = detailViewController.detailTitle else { return }
                
                print("\(previewAction.title) triggered from `DetailsViewController` for item: \(item)")
            }
        }
        
        let actionDefault = previewActionForTitle("收藏")
        let actionShare = previewActionForTitle("分享", style: .destructive)
        let subActionQQ = previewActionForTitle("QQ")
        let subActionWb = previewActionForTitle("微博")
        
        let groupedOptionsActions = UIPreviewActionGroup(title: "分享", style: .default, actions: [subActionQQ, subActionWb] )
        
        return [actionDefault]
        
    }()
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    func collectVideo(){
        
        if  DataCenter.shareDataCenter.user.id == 0{
            return
        }
        
        let userFavorite:UserFavorite = UserFavorite(id: 0, userId: userId, videoId: DataCenter.shareDataCenter.videoInfo.id, status: 1)
        
        if !isC {
            HttpController.onUserAndMovie(HttpClientByUserAndVideo.DSRouter.addUserFavoriteVideo(userFavorite), callback: { (statusCode) -> Void in
                if statusCode == 201{
                    self.isC = true
                    print("收藏成功")
                }
                
            })
         }else{
            print("取消收藏")
            HttpController.onUserAndMovie(HttpClientByUserAndVideo.DSRouter.deleteByUserIdAndVideoId(userId, DataCenter.shareDataCenter.videoInfo.id), callback: { (statusCode) -> Void in
                if statusCode == 200{
                    self.isC = true
                    print("取消收藏成功")
                }
                
            })
        }
    }
    
}

//MARK: - PreviewActions -> DetailsViewController Extension
typealias PreviewActions = PlayVideoViewController
extension PreviewActions  {
    
    /// User swipes upward on a 3D Touch preview
    override var previewActionItems : [UIPreviewActionItem] {
        return previewDetailsActions
    }
}
