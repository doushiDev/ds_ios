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

class PlayVideoViewController: UIViewController,ZFPlayerDelegate,GADBannerViewDelegate,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var playerFatherView: UIView!
     var interstitial: GADInterstitial!
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
    
    func gameOver() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        // Rest of game over logic goes here.
    }
  
    
    override func loadView() {
        
        super.loadView()
        
        loadNewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherVideoTableView.delegate = self
        otherVideoTableView.dataSource = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7191090490730162/4714192339")
        
        let request = GADRequest()
        // Requests test ads on test devices.

//        request.testDevices = ["e2c6cbd54759890e2fb3ac1bdb5abd2f"]
        interstitial.load(request)
        gameOver()
        // Do any additional setup after loading the view.
        
        self.playerView = ZFPlayerView()
        
//        self.fd_prefersNavigationBarHidden = true;

        playerModel.title = videoTitle!
        playerModel.videoURL = videoUrl!
        playerModel.placeholderImage = UIImage(named: "loading_bgView1")
        playerModel.fatherView = self.playerFatherView
         
    
        self.playerView?.playerControlView(nil, playerModel: self.playerModel)
        
        // 设置代理
        self.playerView?.delegate = self;
        self.playerView?.hasPreviewView = true;
        
        self.playerView?.autoPlayTheVideo()
        
        
//        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//
//        bannerView.delegate = self
        adView.delegate = self
        adView.adUnitID = "ca-app-pub-7191090490730162/9842395935"
        adView.frame = CGRect(x: 0, y: -60, width: self.view.frame.width, height: 60)
        adView.rootViewController = self
        adView.load(GADRequest())
        // 获取默认的 Realm 实例
        let realm = try! Realm()
        let fVideo = realm.objects(RealmVideo.self).filter("vid = '\(realmVideo!.vid)'").first
        
        if fVideo != nil {
            favoriteButton.setTitle("取消收藏", for: .normal)
            favoriteButton.tag = 1
        }else {
            favoriteButton.titleLabel?.text = "收藏"
            favoriteButton.setTitle("收藏", for: .normal)

            favoriteButton.tag = 0

        }

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

    
    @IBOutlet weak var adView: GADBannerView!

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
            shareObject.descr = "更多精彩视频，下载搞笑头条APP"
            shareObject.thumbImage = self.videoImage?.image//缩略图
            
            shareObject.webpageUrl = "https://api.toutiao.itjh.net/share.html?title=\(self.videoTitle!)&pic=\(self.videoPic!)&videoUrl=\(self.videoUrlStr!)"
            
            
            if platformType.rawValue == 0 {
                messageObject.text = "\(self.videoTitle!) -- 更多精彩视频，下载搞笑头条APP 下载地址: http://t.cn/Roaq9ZZ"
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

                favoriteButton.tag = 1
            }
        }else {

            try! realm.write {
                let fVideo = realm.objects(RealmVideo.self).filter("vid = '\(realmVideo!.vid)'").first
                if fVideo != nil {
                   realm.delete(fVideo!)
                }
                favoriteButton.setTitle("收藏", for: .normal)

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
        
        self.playerView?.pause()
        
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
