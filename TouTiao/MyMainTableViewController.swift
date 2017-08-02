//
//  MyMainTableViewController.swift
//  ds-ios My页面
//
//  Created by 宋立君 on 15/10/30.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class MyMainTableViewController: UITableViewController {
    @IBOutlet var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(rgba:"#f0a22a")

        self.tableView.tableHeaderView = myImage
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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

