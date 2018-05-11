//
//  PlayVideoViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/25.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import MediaPlayer
import ZFPlayer
import FDFullscreenPopGesture
import GoogleMobileAds
import RealmSwift
import Realm
import Alamofire
import Kingfisher

import HandyJSON
import SwiftyJSON
import AVOSCloud

class PlayVideoViewController: UIViewController,ZFPlayerDelegate,UITableViewDelegate,UITableViewDataSource  {
    
    
    
    @IBOutlet weak var playerFatherView: UIView!
    
    var playerView:ZFPlayerView?
    
    var isPlaying:Bool?
    
    var  playerModel:ZFPlayerModel = ZFPlayerModel()
 
    @IBOutlet weak var otherVideoTableView: UITableView!
    //视频集合
    
    var videos:[Video] = []
    var videoUrl:URL?
    
    var videoUrlStr:String?
    
    var videoTitle:String?
    
    var videoPic:String?
    
    var videoImage:UIImageView?
    
    var realmVideo:RealmVideo?
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var bannerView: GADBannerView!
    
    override func loadView() {
        
        super.loadView()
        print("view frame -> \(self.view.frame)")
        
        print("playerFatherView frame -> \(self.playerFatherView.frame)")

        self.playerFatherView.frame = CGRect(x: 0, y: 34, width: self.view.frame.width, height: 215)
        print("playerFatherView frame -> \(self.playerFatherView.frame)")

        loadNewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherVideoTableView.delegate = self
        otherVideoTableView.dataSource = self
        
        
        let query = AVQuery.init(className: "Google_AdSense")
        
        query.selectKeys(["application_id","ad_unit_id"])
        
        query.getFirstObjectInBackground { (avObject, error) in
            
            
            let av:AVObject = avObject!
            print("application_id -> \(String(describing: av["application_id"]))")
            print("ad_unit_id -> \(String(describing: av["ad_unit_id"]))")
        
        
        
            self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            self.addBannerViewToView(self.bannerView)
            self.bannerView.adUnitID =  av["ad_unit_id"] as? String
            self.bannerView.rootViewController = self
            var request = GADRequest()
            request.testDevices = ["cb5f8f63abdf96116102fcee76276fed"]
            self.bannerView.load(request)
        
        
        
        }
        
        
        self.playerView = ZFPlayerView()
        playerModel.title = videoTitle!
//        playerModel.
        playerModel.videoURL = videoUrl!
        playerModel.placeholderImage = UIImage(named: "loading_bgView1")
        playerModel.fatherView = self.playerFatherView
        self.playerView?.playerControlView(nil, playerModel: self.playerModel)
        
        // 设置代理
        self.playerView?.delegate = self;
        self.playerView?.hasPreviewView = true;
        self.playerView?.autoPlayTheVideo()
        
        // 获取默认的 Realm 实例
        let realm = try! Realm()
        let fVideo = realm.objects(RealmVideo.self).filter("vid = '\(realmVideo!.vid)'").first
        
        if fVideo != nil {
            favoriteButton.setTitle("取消收藏", for: .normal)
            favoriteButton.setImage(UIImage(named: "hearts"), for: .normal)

            favoriteButton.tag = 1
        }else {
            favoriteButton.titleLabel?.text = "收藏"
            favoriteButton.setTitle("收藏", for: .normal)
            favoriteButton.setImage(UIImage(named: "noheart"), for: .normal)

            favoriteButton.tag = 0

        }

    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
 
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .height,
                                multiplier: 1,
                                constant: 70)
            ])
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoTableViewCell", for: indexPath) as! HomeVideoTableViewCell
        
        if videos.count > 0 {
            
            
            let url = URL(string: videos[indexPath.row].pic!)
            
            cell.videoImageView.kf.setImage(with: url, placeholder: Image(named:"moren"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
            
            
            cell.videoTitleLabel.text = videos[indexPath.row].title
            
            
        }else {
        
            cell.videoTitleLabel.text = "搞笑视频在等着你"
            cell.videoImageView.image = UIImage(named: "moren")
        }
        
        
        
        return cell

    }
    
    
    // MARK: - Table view data source
    // 加载新数据
    func loadNewData(){
        
        Alamofire.request("https://api.toutiao.itjh.net/v1.0/rest/video/getVideosByType/0/30/33").responseJSON { response in
            
            
            switch response.result {
                
            case .success:
                
                if let JSONData = response.result.value {
                    if let videoList = JSONDeserializer<Video>.deserializeModelArrayFrom(json: JSON(JSONData)["content"].rawString()) {
                        
                        self.videos = videoList as! [Video]
                        self.otherVideoTableView.reloadData()
                        
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
            
            
        }
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
    }


    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    override var shouldAutorotate: Bool {
    
        return false
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        print("分享")
        
        UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { (platformType, userInfo) in
            
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "推荐一个专注搞笑视频的应用"//分享的文本
            
            
            //2.分享分享网页
            let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
            
            shareObject.title = self.videoTitle
            shareObject.descr = "逗音视频 - 好玩人的视频都在这"
            shareObject.thumbImage = self.videoImage?.image//缩略图
            
            shareObject.webpageUrl = "https://api.toutiao.itjh.net/share.html?title=\(self.videoTitle!)&pic=\(self.videoPic!)&videoUrl=\(self.videoUrlStr!)"
            
            
            if platformType.rawValue == 0 {
                messageObject.text = "\(self.videoTitle!) -- 逗音视频 - 好玩人的视频都在这 下载地址: http://t.cn/Roaq9ZZ"
                //创建图片内容对象
                
                let shareImage = UMShareImageObject()
                shareImage.thumbImage = self.videoImage?.image//缩略图
                shareImage.shareImage = "https://ws1.sinaimg.cn/large/006tNc79ly1fgwkuqrpzkj3050050jrf.jpg"
                messageObject.shareObject = shareImage
            }else{
                messageObject.shareObject = shareObject;
            }
            
            
            
            
            
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) in
                if error != nil {
                    print("Share Fail with error ：%@", error!)
                }else{
                    print("Share succeed")
                }
            })
            
        })
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        print("收藏")
        print(realmVideo!)
        
        // 获取默认的 Realm 实例
        let realm = try! Realm()
        
        print(realm.configuration.fileURL!)
        
        if favoriteButton.tag == 0{
            // 通过事务将数据添加到 Realm 中
            try! realm.write {
                let currentdate = Date()
                realmVideo!.createDate = "\(currentdate.timeIntervalSince1970)"
                
                realm.create(RealmVideo.self, value: realmVideo!, update: true)
//                realm.add(realmVideo!, update: true)
                
                
                favoriteButton.setTitle("取消收藏", for: .normal)
                
                
                
                favoriteButton.setImage(UIImage(named: "hearts"), for: .normal)

                favoriteButton.tag = 1
            }
        }else {

            try! realm.write {
                let fVideo = realm.objects(RealmVideo.self).filter("vid = '\(realmVideo!.vid)'").first
                if fVideo != nil {
                   realm.delete(fVideo!)
                }
                favoriteButton.setTitle("收藏", for: .normal)
                favoriteButton.setImage(UIImage(named:"noheart"), for: UIControlState.normal)
                
                favoriteButton.tag = 0
            }
        }
        
        
        
        
    }
    
    // MARK: - ZFPlayerDelegate
    
    func zf_playerBackAction() {
        print("asd")
        self.navigationController?.popViewController(animated: true)
        
//        let _ = navigationController?.popToRootViewController(animated: true)
        
        //
//        self.navigationController?.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Getter
    
//    override func perform(_ aSelector: Selector, with anArgument: Any?, afterDelay delay: TimeInterval, inModes modes: [RunLoopMode]) {
//        
////        if (!playerModel) {
////            _playerModel                  = [[ZFPlayerModel alloc] init];
////            _playerModel.title            = @"这里设置视频标题";
////            _playerModel.videoURL         = self.videoURL;
////            _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
////            _playerModel.fatherView       = self.playerFatherView;
////            
////        }
////        return _playerModel;
//
//        
//        
//    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true

        UIApplication.shared.statusBarStyle = .lightContent
        
//        if self.navigationController?.viewControllers.count == 2 && (self.playerView != nil) && self.isPlaying! {
//            self.isPlaying = false
//            self.playerView?.play()
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.isPlaying = false
        
        self.playerView?.play()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if self.navigationController?.viewControllers.count == 3 && (self.playerView != nil) && (self.playerView?.isPauseByUser)! {
            self.isPlaying = true
            self.playerView?.pause()
        }
        
        self.playerView?.pause()

    }
    
    func zf_playerControlViewWillHidden(_ controlView: UIView!, isFullscreen fullscreen: Bool) {
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // 播放页面隐藏tabbar
        //        if segue.identifier == "toPlayVideo" {
        
        let path = self.otherVideoTableView.indexPathForSelectedRow!
        
        self.playerView?.stopPlayWhileCellNotVisable = true
        if let playVideoViewController = segue.destination as? PlayVideoViewController {
            
            
            let url = URL(string: self.videos[path.row].videoUrl)
            //
            playVideoViewController.videoUrl = url
            playVideoViewController.videoTitle = self.videos[path.row].title
            playVideoViewController.videoUrlStr = self.videos[path.row].videoUrl
            playVideoViewController.videoPic = self.videos[path.row].pic
            
            let cell = otherVideoTableView.cellForRow(at: path) as! HomeVideoTableViewCell
            
            playVideoViewController.videoImage = cell.videoImageView
            
            let video:RealmVideo = RealmVideo()
            video.vid = self.videos[path.row].vid!
            video.videoUrl = self.videos[path.row].videoUrl
            video.pic = self.videos[path.row].pic!
            video.title = self.videos[path.row].title!
            video.shareUrl = self.videos[path.row].shareUrl
            video.at = self.videos[path.row].at
            playVideoViewController.realmVideo = video
            if video.at != 1 {
                
                //            return
                
                MobClick.event("ads")
                
                let evaluateString = self.videos[path.row].videoUrl
                
                UIApplication.shared.openURL(URL(string: evaluateString)!)
                
            }else {
                
                //                self.navigationController?.pushViewController(playVideoViewController, animated: true)
            }
        }
        //        }
    }


}
