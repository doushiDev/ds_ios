//
//  PlayVideoTableViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/26.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import MediaPlayer
import ZFPlayer
import FDFullscreenPopGesture

class PlayVideoTableViewController: UITableViewController,ZFPlayerDelegate {

    @IBOutlet weak var playVideoView: UIView!
    
    var playerView:ZFPlayerView?
    
    var isPlaying:Bool?
    
    var  playerModel:ZFPlayerModel = ZFPlayerModel()
    
    
    var videoUrl:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = playVideoView

        
        //        self.fd_prefersNavigationBarHidden = true;
        
        playerModel.title = "title"
        playerModel.videoURL = videoUrl!
        playerModel.placeholderImage = UIImage(named: "loading_bgView1")
        playerModel.fatherView = self.playVideoView
        
        
        self.playerView?.playerControlView(nil, playerModel: self.playerModel)
        
        // 设置代理
        self.playerView?.delegate = self;
        self.playerView?.hasPreviewView = true;
        
        self.playerView?.autoPlayTheVideo()
        
//        self.view.addSubview(playVideoView)
        

        
    }
    override var shouldAutorotate: Bool {
        
        return false
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
    }
    
    // MARK: - ZFPlayerDelegate
    
    func zf_playerBackAction() {
        print("asd")
        //        self.navigationController?.popViewController(animated: true)
        
        let _ = navigationController?.popToRootViewController(animated: true)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if self.navigationController?.viewControllers.count == 3 && (self.playerView != nil) && (self.playerView?.isPauseByUser)! {
            self.isPlaying = true
            self.playerView?.pause()
        }
        
        self.playerView?.pause()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath)

        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
