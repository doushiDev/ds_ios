//
//  MyUserFavoriteTableViewController.swift
//  ds-ios 用户收藏table
//
//  Created by 宋立君 on 15/11/18.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import Kingfisher

class MyUserFavoriteTableViewController: UITableViewController {


	//视频集合
	var videos = NSMutableOrderedSet()

	//请求视频状态
	var populatingVideo = false

	// 起始页码
	var currentPage = 0

	@IBOutlet var topView: UIView!

	let config = URLSessionConfiguration.default

	// 视频分类
	var type = 0

	var alertController: UIAlertController?


	var userId = 0


	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.navigationBar.tintColor = UIColor(rgba: "#f0a22a")

		setNav()

		let user = userDefaults.object(forKey: "userInfo")
		let aStoryboard = UIStoryboard(name: "My", bundle: Bundle.main)

		if (user == nil) {
			//弹窗登录
			let title = "您还没有登录"
			let message = "收藏功能需要用户登录，进行云同步."

			let otherButtonTitle = "去登录"

			let alertCotroller = DOAlertController(title: title, message: message, preferredStyle: .alert)


			let otherAction = DOAlertAction(title: otherButtonTitle, style: .default) {action in
				print("登录")
				let loginTableView = aStoryboard.instantiateViewController(withIdentifier: "LoginView")
				self.navigationController?.pushViewController(loginTableView, animated: true)

			}

			// Add the actions.
			//            alertCotroller.addAction(cancelAction)
			alertCotroller.addAction(otherAction)

			present(alertCotroller, animated: true, completion: nil)

		} else {

			if user != nil {
				userId = (user! as AnyObject).object(forKey: "id") as! Int
			}

			//设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
			self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
					self.loadNewData()

				})

			self.tableView.mj_header.beginRefreshing()
			//
			self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {() -> Void in
					self.loadMoreData()

				})
			self.tableView.mj_footer.isHidden = true
		}





	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.navigationBar.barStyle = UIBarStyle.default
		self.navigationController?.navigationBar.isHidden = false

	}

	/**
	 视图全部加载完 出现

	 - parameter animated: animated description
	 */
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}




	// MARK: - Table view data source
	// 加载新数据
	func loadNewData() {

		self.currentPage = 0
		if populatingVideo {
			return
		}
		populatingVideo = true

		HttpController.getVideos(HttpClientByUserAndVideo.DSRouter.getVideosByUserId(userId, currentPage, 20)) {videoInfos in

			if videoInfos != nil {
				self.videos = []
				self.videos.addObjects(from: videoInfos!)

				self.tableView.reloadData()

				self.currentPage += 1

			}
			self.tableView.mj_header.endRefreshing()
			self.populatingVideo = false
		}


	}



	/**
	 上拉加载更多数据
	 */
	func loadMoreData() {


		if populatingVideo {
			return
		}

		populatingVideo = true


		HttpController.getVideos(HttpClientByUserAndVideo.DSRouter.getVideosByUserId(userId, currentPage, 20)) {videoInfos in

			if videoInfos != nil {

				self.videos.addObjects(from: videoInfos!)

				self.tableView.reloadData()

				self.currentPage += 1

			}
			self.tableView.mj_footer.endRefreshing()
			self.populatingVideo = false
		}
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return self.videos.count
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {



		let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell

		if videos.count > 0 {
			let videoInfo = (videos.object(at: (indexPath as NSIndexPath).row) as! VideoInfo)

			cell.titleLabel.text = videoInfo.title
			cell.picImageView.kf_setImageWithURL(URL(string: videoInfo.pic)!)

		}


		return cell
	}


	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}




	/*
	 // Override to support conditional editing of the table view.
	 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
	 // Return false if you do not want the specified item to be editable.
	 return true
	 }
	 */

	/*
	 // Override to support editing the table view.
	 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
	 if editingStyle == .Delete {
	 // Delete the row from the data source
	 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
	 } else if editingStyle == .Insert {
	 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	 }
	 }
	 */

	/*
	 // Override to support rearranging the table view.
	 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

	 }
	 */

	/*
	 // Override to support conditional rearranging of the table view.
	 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
	 // Return false if you do not want the item to be re-orderable.
	 return true
	 }
	 */

	/*
	 // MARK: - Navigation
	 */
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "toPlayVideo" {

			let path = self.tableView.indexPathForSelectedRow!
			let videoInfo = (videos.object(at: (path as NSIndexPath).row) as! VideoInfo)

			DataCenter.shareDataCenter.videoInfo = videoInfo

			let playVideoViewController = segue.destination as! PlayVideoViewController
			playVideoViewController.userId = userId
		}
	}

}
