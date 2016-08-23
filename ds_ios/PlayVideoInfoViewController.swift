//
//  PalyVideoInfoViewController.swift
//  ds-ios
//
//  Created by Songlijun on 15/10/24.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import Kingfisher
//import GoogleMobileAds

class PlayVideoInfoViewController: UIViewController {


	@IBOutlet weak var videoTitleLabel: UILabel!

	@IBOutlet weak var videoInfoLable: UITextView!

	@IBOutlet weak var bannerView: UIView!

	var userId = 0

	@IBOutlet weak var collectUIButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

//		let bannerView = GADBannerView()
//        
//
////		bannerView.backgroundColor = UIColor.redColor()
//		bannerView.frame = CGRect(x: 0, y: self.view.bounds.width - 80 , width: self.view.bounds.width, height: 80)
////
//////		        bannerView.frame = self.view.frame
////
////        print("bannerView-> \(bannerView.frame)")
////        
//		// 添加Google广告
//		bannerView.adUnitID = "ca-app-pub-7191090490730162/9315670338"
//		bannerView.rootViewController = self;
//		let request = GADRequest()
////		request.testDevices = ["7fa45ea242e06acf374bbde4d05916e0"]
//		bannerView.loadRequest(request)
//		self.view.addSubview(bannerView)


		if DataCenter.shareDataCenter.user.id != 0 {
			userId = DataCenter.shareDataCenter.user.id
		}

		self.videoTitleLabel.text = DataCenter.shareDataCenter.videoInfo.title



		self.collectUIButton.enabled = false

		//判断用户是否收藏过
		HttpController.getVideoById(HttpClientByVideo.DSRouter.getVideosById(DataCenter.shareDataCenter.videoInfo.id, self.userId), callback: {videoInfo -> Void in

				if videoInfo?.isCollectStatus == 1 {
					self.isC = true
					self.collectUIButton.setImage(UIImage(named: "cloud"), forState: .Normal)

				}
				self.collectUIButton.enabled = true
			})
	}


	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		let user = userDefaults.objectForKey("userInfo")

		if user != nil {
			userId = user!.objectForKey("id") as! Int
		}
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var collectButton: UIButton!


	var isC = false

	/**
	 收藏

	 - parameter sender: sender description
	 */
	@IBAction func collectVideo(sender: UIButton) {
		print("点击了收藏")

		//判断当前是否登录状态

		let user = userDefaults.objectForKey("userInfo")
		let aStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())

		if (user == nil) {
			//弹窗登录
			let title = "您还没有登录"
			let message = "收藏功能需要用户登录，进行云同步."
			let cancelButtonTitle = "看得正起劲"
			let otherButtonTitle = "去登录"

			let alertCotroller = DOAlertController(title: title, message: message, preferredStyle: .Alert)

			// Create the actions.
			let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .Cancel) {action in
				NSLog("The \"Okay/Cancel\" alert's cancel action occured.")
			}

			let otherAction = DOAlertAction(title: otherButtonTitle, style: .Default) {action in
				print("登录")
				let loginTableView = aStoryboard.instantiateViewControllerWithIdentifier("LoginView")
				self.navigationController?.pushViewController(loginTableView, animated: true)

			}

			// Add the actions.
			alertCotroller.addAction(cancelAction)
			alertCotroller.addAction(otherAction)

			presentViewController(alertCotroller, animated: true, completion: nil)

		} else {

			if user != nil {
				userId = user!.objectForKey("id") as! Int
			}

			let userFavorite: UserFavorite = UserFavorite(id: 0, userId: userId, videoId: DataCenter.shareDataCenter.videoInfo.id, status: 1)

			if !isC {
				//请求收藏
				HttpController.onUserAndMovie(HttpClientByUserAndVideo.DSRouter.addUserFavoriteVideo(userFavorite), callback: {(statusCode) -> Void in
						if statusCode == 201 {
							sender.setImage(UIImage(named: "cloud"), forState:
									.Normal)
							self.isC = true
							print("收藏成功")
						}

					})
			} else {
				print("取消收藏")
				//请求取消收藏
				HttpController.onUserAndMovie(HttpClientByUserAndVideo.DSRouter.deleteByUserIdAndVideoId(userId, DataCenter.shareDataCenter.videoInfo.id), callback: {(statusCode) -> Void in
						if statusCode == 200 {
							sender.setImage(UIImage(named: "cloud_d"), forState:
									.Normal)
							self.isC = false
							print("取消收藏成功")
						}
					})
			}
		}
	}

	/**
	 分享

	 - parameter sender: sender description
	 */
	@IBAction func shareAction(sender: UIButton) {


		print("点击了分享")
		let share = "https://api.ds.itjh.net/share.html?id=\(DataCenter.shareDataCenter.videoInfo.id)"


		let saimg = UIImage(data: NSData(contentsOfURL: NSURL(string: DataCenter.shareDataCenter.videoInfo.pic)!)!)

		UMSocialData.defaultData().extConfig.title = DataCenter.shareDataCenter.videoInfo.title

		UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "\(share)")

		UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "\(share)")


		let snsArray = [UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQQ, UMShareToQzone, UMShareToSina, UMShareToFacebook, UMShareToTwitter, UMShareToEmail]


		UMSocialSnsService.presentSnsIconSheetView(self, appKey: "563b6bdc67e58e73ee002acd", shareText: DataCenter.shareDataCenter.videoInfo.title + "   " + share, shareImage: saimg, shareToSnsNames: snsArray, delegate: nil)

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
