//
//  FavoriteVideosTableViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/26.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Kingfisher

class FavoriteVideosTableViewController: UITableViewController {
    
    var videos:Results<RealmVideo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadData()
        
        
//        self.view.addSubview(notFavoriteView)
    }
    @IBOutlet var notFavoriteView: UIView!
    
    @IBOutlet weak var notLabel: UILabel!
    func loadData() {
        
        // 获取默认的 Realm 实例
        let realm = try! Realm()
        
        videos = realm.objects(RealmVideo.self).sorted(byKeyPath: "createDate", ascending: false)
        
        if((videos?.count)! > 0){
//            self.notFavoriteView.isHidden = true
            self.notLabel.isHidden = true
        }else{
//            self.notFavoriteView.isHidden = false
            self.notLabel.isHidden = false

        }
        
        self.tableView.reloadData()
        
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
        return (videos?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoTableViewCell", for: indexPath) as! HomeVideoTableViewCell
        
        // Configure the cell...
        let url = URL(string: videos![indexPath.row].pic)
        
        cell.videoImageView.kf.setImage(with: url, placeholder: Image(named:"moren"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        
        
        cell.videoTitleLabel.text = videos?[indexPath.row].title
        
        
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
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
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let videoViewController = segue.destination as! PlayVideoViewController
        
        let cell = sender as! HomeVideoTableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        
        
        self.tableView.deselectRow(at: indexPath!, animated: true)
        
        let url = URL(string: self.videos![indexPath!.row].videoUrl)
        
        videoViewController.videoUrl = url
        videoViewController.videoTitle = self.videos![indexPath!.row].title
        
        videoViewController.videoUrlStr = self.videos![indexPath!.row].videoUrl
        videoViewController.videoPic = self.videos![indexPath!.row].pic
        
        videoViewController.videoImage = cell.videoImageView
        
        let video:RealmVideo = RealmVideo()
        video.vid = self.videos![indexPath!.row].vid
        video.videoUrl = self.videos![indexPath!.row].videoUrl
        video.pic = self.videos![indexPath!.row].pic
        video.title = self.videos![indexPath!.row].title
        video.shareUrl = self.videos![indexPath!.row].shareUrl
        
        videoViewController.realmVideo = video
        
    }
    
}
