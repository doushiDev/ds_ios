//
//  MyMainTableViewController.swift
//  ds-ios My页面
//
//  Created by 宋立君 on 15/10/30.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import SnapKit


class MyMainTableViewController: UITableViewController {
    @IBOutlet var myImage: UIImageView!

    @IBOutlet weak var myBackImageView: UIImageView!
    
    @IBOutlet weak var headerView: UIView!

    
    let userCircle = UIImageView(frame: CGRect(x: 0,y: 0,width: 80,height: 80))
    
    let loginButton = UIButton(frame: CGRect(x: 0, y: 200, width: 80, height: 20))
    
    @IBOutlet weak var loginStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")
//        self.tableView.tableHeaderView = myImage
        loginButton.isEnabled = true

    }
    
    override func loadView() {
        super.loadView()
        
        self.headerView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 220)
        
        userCircle.alpha = 1
        userCircle.center = myBackImageView.center
        userCircle.layer.masksToBounds = true
        userCircle.layer.cornerRadius = 35
        userCircle.isUserInteractionEnabled = true
        let userCircleTap = UITapGestureRecognizer()
        userCircleTap.addTarget(self, action: #selector(MyMainTableViewController.userCircleAction))
        userCircle.addGestureRecognizer(userCircleTap)
        myBackImageView.addSubview(userCircle)
        
        
        loginButton.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 16)
        myBackImageView.addSubview(loginButton)
        

        loginButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userCircle.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.centerX.equalTo(myBackImageView)
        }
        
        userCircle.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(70)
            make.center.equalTo(myBackImageView)
        }
        
        // 设置用户头像
        userCircle.image = UIImage(named: "touxiang")
        
        // 设置login
        loginButton.setTitle("立即登录", for: UIControlState())
        
        loginButton.addTarget(self, action: #selector(MyMainTableViewController.toLoginView(_:)), for: .touchUpInside)

    }
    
    func userCircleAction() {
        if loginButton.isEnabled {
            
            showLoginView()
        }
        
    }
    
    func showLoginView() {

        print("d 点击登录")
        
//        let loginViewController = YHConfig.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        self.present(loginViewController, animated: true, completion: nil)
        
    }
    
    /**
     跳转登录页面
     */
    func toLoginView(_ sender: UIButton!){
        
        print("点击了登录")
        
//        let loginViewController = YHConfig.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        self.present(loginViewController, animated: true, completion: nil)
//
        
        alertLogin()
        
    }
    
    func alertLogin() {
        
        
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 70))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        let textfield1 = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        //        textfield1.layer.borderColor = UIColor.green.cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "手机号"
        textfield1.keyboardType = .phonePad
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
        
        // Add textfield 2
        let textfield2 = UITextField(frame: CGRect(x: x,y: textfield1.frame.maxY + 10,width: 180,height: 25))
        textfield2.isSecureTextEntry = true
        //        textfield2.layer.borderColor = UIColor.blue.cgColor
        textfield2.layer.borderWidth = 1.5
        textfield2.layer.cornerRadius = 5
        textfield1.layer.borderColor = UIColor.blue.cgColor
        textfield2.placeholder = "密码"
        textfield2.isSecureTextEntry = true
        textfield2.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield2)
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        _ = alert.addButton("登录/注册") {
            print("Logged in")
            
//            textfield1.text
            if !self.validateMobile(phone: textfield1.text!) {
                
                print("手机号不对")
                
            }
            
        }
        _ = alert.addButton("关闭",backgroundColor: UIColor.gray) {
            
            print("关闭")
        }
        
        
        
        _ = alert.showInfo("登录/注册", subTitle: "", duration: 10)
        
    }
    
    func validateMobile(phone: String) -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(16[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    
    func setHeadImage(){
        
        if let userDic:Dictionary =  UserDefaults.standard.dictionary(forKey: "user") {
            
//            let url = URL(string: userDic["headImage"] as! String)
            
//            self.userCircle.kf.setImage(with: url, placeholder: Image(named:"picture-default"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
//
//            self.loginButton.setTitle(userDic["nickName"] as? String, for: UIControlState())
            self.loginButton.isEnabled = false
            //禁止点击
            loginButton.isEnabled = false
            loginStatusLabel.text = "退出当前用户"
            loginStatusLabel.textColor = UIColor.red
        
            
            
        }else{
            loginButton.setTitle("立即登录", for: UIControlState())
            loginButton.isEnabled = true
            userCircle.image = UIImage(named: "touxiang")
            loginStatusLabel.text = "立即登录"
            loginStatusLabel.textColor = UIColor(rgba: "#f5436d")
            
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 刷新用户信息
        
        setHeadImage()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            
        }
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1{
            print("意见反馈")
            let evaluateString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1044917946&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            UIApplication.shared.openURL(URL(string: evaluateString)!)
        }
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            print("给个笑脸")
            let evaluateString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1044917946&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            UIApplication.shared.openURL(URL(string: evaluateString)!)
            
        }
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 2 {
            print("免责声明")
            UIApplication.shared.openURL(URL(string: "https://api.toutiao.itjh.net/mzsm.html"
)!)        }
        
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
            print("朋友推荐")            
            
            UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { (platformType, userInfo) in
                
                let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
                messageObject.text = "推荐一个专注搞笑视频的应用"//分享的文本
                
                
                //2.分享分享网页
                let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
                shareObject.title = "推荐一个专注搞笑视频的应用"
                shareObject.descr = "搞笑头条,瞬间让你好看,试试看吧"
                shareObject.thumbImage = UIImage.init(named: "Icon-60")//缩略图
                shareObject.webpageUrl = "https://api.toutiao.itjh.net/share.html?title=%E5%8D%95%E8%BA%AB%E7%8B%97%E5%9C%A8%E5%AF%82%E5%AF%9E%E7%9A%84%E5%A4%9C%E9%87%8C%E9%83%BD%E4%BC%9A%E5%B9%B2%E5%98%9B&pic=http://img.mms.v1.cn/static/mms/images/2017-02-14/201702141510141635.jpg&videoUrl=http://f04.v1.cn/transcode/14478674MOBILET2.mp4&type=1"
                
                if platformType.rawValue == 0 {
                    messageObject.text = "推荐一个专注搞笑视频的应用 -- 搞笑头条,瞬间让你好看,试试看吧！下载地址: http://t.cn/Roaq9ZZ"
                    //创建图片内容对象
                    
                    let shareImage = UMShareImageObject()
                    shareImage.thumbImage = UIImage.init(named: "Icon-60")//缩略图
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
        
        if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 0 {
            
            
            if let userCircle:Dictionary =  UserDefaults.standard.dictionary(forKey: "user"){
                
                print("登出")
                //确定按钮
                let alertController = UIAlertController(title: "确定要退出吗？", message: "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                    
                    
                    UserDefaults.standard.removeObject(forKey: "user")
                    DSDataCenter.sharedInstance.user = User()
                    
                    self.setHeadImage()
                    
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                }
            }else{
                print("点击了登录")
//                let loginViewController = YHConfig.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//                self.present(loginViewController, animated: true, completion: nil)
                alertLogin()
            }
        }
        
        
        
        
        
    }
    
    
    //发送邮件功能
    func sendEmailAction(){
        //        let mailComposeViewController = configuredMailComposeViewController()
        //        if mailComposeViewController.canSendMail() {
        //            self.present(mailComposeViewController, animated: true, completion: nil)
        //        }
    }
    
    //    func configuredMailComposeViewController() -> MFMailComposeViewController {
    //        let mailComposerVC = mailComposeController()
    //        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    //        //设置收件人
    //        mailComposerVC.setToRecipients(["iosdev@itjh.com.cn"])
    //        //设置主题
    //        mailComposerVC.setSubject("搞笑头条意见反馈")
    //        //邮件内容
    //        let info:Dictionary = Bundle.main.infoDictionary!
    //        let appName = info["CFBundleName"] as! String
    //        let appVersion = info["CFBundleShortVersionString"] as! String
    //        mailComposerVC.setMessageBody("</br></br></br></br></br>基本信息：</br></br>\(appName)  \(appVersion)</br> \(UIDevice.current.name)</br>iOS \(UIDevice.current.systemVersion)", isHTML: true)
    //        return mailComposerVC
    //    }
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func sendEmail() {
        //        if mailComposeController.canSendMail() {
        //            let mailComposerVC = mailComposeController()
        //
        //            mailComposerVC.setToRecipients(["iosdev@itjh.com.cn"])
        //            //设置主题
        //            mailComposerVC.setSubject("搞笑头条意见反馈")
        //            //邮件内容
        //            let info:Dictionary = Bundle.main.infoDictionary!
        //            let appName = info["CFBundleName"] as! String
        //            let appVersion = info["CFBundleShortVersionString"] as! String
        //            mailComposerVC.setMessageBody("</br></br></br></br></br>基本信息：</br></br>\(appName)  \(appVersion)</br> \(UIDevice.current.name)</br>iOS \(UIDevice.current.systemVersion)", isHTML: true)
        //
        ////            mail.mailComposeDelegate = self
        ////            mail.setToRecipients(["paul@hackingwithswift.com"])
        ////            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
        ////
        //            present(mailComposerVC, animated: true)
        //        } else {
        //            // show failure alert
        //        }
    }
    
    //    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    //        controller.dismiss(animated: true)
    //    }
    
    
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
    
    
}

extension MyMainTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let Offset_y = scrollView.contentOffset.y
        // 下拉 纵向偏移量变小 变成负的
        if ( Offset_y < 0) {
            // 拉伸后图片的高度
            let totalOffset = 200 - Offset_y;
            // 图片放大比例
            let scale = totalOffset / 200;
            let width = UIScreen.main.bounds.width
            // 拉伸后图片位置
            myBackImageView!.frame = CGRect(x: -(width * scale - width) / 2, y: Offset_y, width: width * scale, height: totalOffset);
            
        }
        
    }
    
}

