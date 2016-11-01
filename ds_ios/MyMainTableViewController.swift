//
//  MyMainTableViewController.swift
//  ds-ios My页面
//
//  Created by 宋立君 on 15/10/30.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
//import VGParallaxHeader
import APParallaxHeader

class MyMainTableViewController: UITableViewController,APParallaxViewDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    
    var mybkImage: UIImageView!
    @IBOutlet weak var loginStatusLabel: UILabel!

    let userCircle = UIImageView(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
    
    
    let loginButton = UIButton(frame: CGRect(x: 0, y: 200, width: 80, height: 20))
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        self.navigationController?.navigationBar.isHidden  = true
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        mybkImage = UIImageView(image: UIImage(named: "mybk1"))
        mybkImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        mybkImage.isUserInteractionEnabled = true
        
        
       
        
        userCircle.alpha = 1
        userCircle.center = mybkImage.center
        userCircle.layer.masksToBounds = true
        userCircle.layer.cornerRadius = 35
        userCircle.layer.borderColor = UIColor(rgba:"#f0a22a").cgColor
        userCircle.layer.borderWidth = 2
        mybkImage.addSubview(userCircle)
        
        ///登录 按钮 
        
//                loginButton.setImage(UIImage(named: "login"), forState: .Normal)
        loginButton.addTarget(self, action: #selector(MyMainTableViewController.toLoginView(_:)), for: .touchUpInside)
                mybkImage.addSubview(loginButton)
        
        loginButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)


        loginButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userCircle.snp_bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.centerX.equalTo(mybkImage)
        }
        
        userCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(70)
            make.center.equalTo(mybkImage)
        }
        
        //添加tableHeaderView
        let headerView_v: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderView(withSubView: mybkImage) as! ParallaxHeaderView
        
        
        self.tableView.tableHeaderView = headerView_v
        
        /// 用户头像
        setHeadImage()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isHidden = true
       setHeadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //添加tableHeaderView
        let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.refreshBlurViewForNewImage()
        self.tableView.tableHeaderView = header
    }
    
    
    
    /**
     跳转登录页面
     */
    func toLoginView(_ sender: UIButton!){
        let aStoryboard = UIStoryboard(name: "My", bundle:Bundle.main)
        
        let loginTableView = aStoryboard.instantiateViewController(withIdentifier: "LoginView")
        self.navigationController?.pushViewController(loginTableView, animated: true)
        
        print("点击了登录")
    }
    
    
    //MARK: 滑动操作
    override func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.tableView){
            let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
            header.layoutHeaderView(forScrollOffset: scrollView.contentOffset)
            self.tableView.tableHeaderView = header
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 20
        }else{
            return 20
        }
    }
    
    
    func setHeadImage(){
        
        let user =  userDefaults.object(forKey: "userInfo")

        if (user != nil) {
            let headImageUrl = (user! as AnyObject).object(forKey: "headImage") as! String
            let nickName = (user! as AnyObject).object(forKey: "nickName") as! String
          
                userCircle.kf_setImageWithURL(URL(string: headImageUrl)!)
                loginButton.setTitle(nickName, for: UIControlState())
                //禁止点击
                loginButton.isEnabled = false
            loginStatusLabel.text = "退出当前用户"
            loginStatusLabel.textColor = UIColor.red
            
 
        }else{
            loginButton.setTitle("立即登录", for: UIControlState())
            loginButton.isEnabled = true
            userCircle.image = UIImage(named: "picture-default")
            loginStatusLabel.text = "立即登录"
            loginStatusLabel.textColor = UIColor.green
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            print("点击了我的收藏")
            //判断用户是否登录
            let user =  userDefaults.object(forKey: "userInfo")
            let aStoryboard = UIStoryboard(name: "My", bundle:Bundle.main)
            
            if (user == nil) {
                //弹窗登录
               
                let loginTableView = aStoryboard.instantiateViewController(withIdentifier: "LoginView")
                self.navigationController?.pushViewController(loginTableView, animated: true)
                
            }else{
                
                let myUserFavoriteTableViewController =  aStoryboard.instantiateViewController(withIdentifier: "MyCollect") as! MyUserFavoriteTableViewController
                myUserFavoriteTableViewController.userId = (user! as AnyObject).object(forKey: "id") as! Int
                 self.navigationController?.pushViewController(myUserFavoriteTableViewController, animated: true)

            }
        }
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1{
            print("意见反馈")
            sendEmailAction()
        }
        
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0{
            print("给个笑脸")
            let evaluateString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1044917946&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            UIApplication.shared.openURL(URL(string: evaluateString)!)
            
        }
        
        if (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 0 {
            let user =  userDefaults.object(forKey: "userInfo")

            if user != nil{
                print("登出")
                //确定按钮
                let alertController = UIAlertController(title: "确定要退出吗？", message: "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                 }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                    
                    self.loginStatusLabel.text = "立即登录"
                    self.loginStatusLabel.textColor = UIColor.green
                    userDefaults.removeObject(forKey: "userInfo")
                    DataCenter.shareDataCenter.user = User()
                    self.setHeadImage()

                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                 }
            }else{
                print("登录")
                loginStatusLabel.text = "退出当前用户"
                loginStatusLabel.textColor = UIColor.red
                let aStoryboard = UIStoryboard(name: "My", bundle:Bundle.main)
                
                let loginTableView = aStoryboard.instantiateViewController(withIdentifier: "LoginView")
                self.navigationController?.pushViewController(loginTableView, animated: true)
                setHeadImage()

            }
        }
        
        if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1 {
            print("朋友推荐")
            let share = "https://itunes.apple.com/cn/app/id1044917946"
            
            
            
            UMSocialData.default().extConfig.title = "搞笑,恶搞视频全聚合,尽在逗视App"
            
            UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "\(share)")
            
            UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "\(share)")

            
            let snsArray = [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToFacebook,UMShareToTwitter,UMShareToEmail]
            
            
            UMSocialSnsService.presentSnsIconSheetView(self, appKey: "563b6bdc67e58e73ee002acd", shareText:"搞笑,恶搞视频全聚合,尽在逗视App   " + share, shareImage: UIImage(named: "doushi_icon"), shareToSnsNames: snsArray, delegate: nil)
             
         }
        
    }
    
    
    //发送邮件功能
    func sendEmailAction(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        //设置收件人
        mailComposerVC.setToRecipients(["iosdev@itjh.com.cn"])
        //设置主题
        mailComposerVC.setSubject("逗视意见反馈")
        //邮件内容
        let info:Dictionary = Bundle.main.infoDictionary!
        let appName = info["CFBundleName"] as! String
        let appVersion = info["CFBundleShortVersionString"] as! String
        mailComposerVC.setMessageBody("</br></br></br></br></br>基本信息：</br></br>\(appName)  \(appVersion)</br> \(UIDevice.current.name)</br>iOS \(UIDevice.current.systemVersion)", isHTML: true)
        return mailComposerVC
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUserFavorite" {
            
        }
//
    }
    

}
