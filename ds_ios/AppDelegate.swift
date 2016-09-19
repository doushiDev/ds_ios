//
//  AppDelegate.swift
//  ds_ios
//
//  Created by 宋立君 on 15/11/27.
//  Copyright © 2015年 宋立君. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Alamofire
import Fabric
import Answers
import GoogleMobileAds


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    var interstitial: GADInterstitial!
    
//    @property (strong, nonatomic) UIView *launchView;
//    @property (nonatomic,strong) UIImageView * imgBg;

    
    var launchView:UIView?
    var imgBg:UIImageView?
    var oldLaunchView:UIImageView?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
//        Ad unit ID: ca-app-pub-7191090490730162/5860625531
        
        
//        initAd()

        
        
        // Override point for customization after application launch.
        Fabric.with([Answers.self])

        
        //判断用户是否登录
        
        if userDefaults.object(forKey: "userInfo") != nil {
            
            let userDictionary = userDefaults.object(forKey: "userInfo") as! NSDictionary
            
            let userInfo = User(id: userDictionary["id"] as! Int,
                
                nickName: userDictionary["nickName"] as! String,
                password: "",
                headImage: userDictionary["headImage"] as! String,
                phone: userDictionary["phone"] as! String,
                gender: userDictionary["gender"] as! Int,
                platformId: userDictionary["platformId"] as! String,
                platformName: userDictionary["platformName"] as! String)
            
            DataCenter.shareDataCenter.user = userInfo
            
        }
        
        
        Thread.sleep(forTimeInterval: 1.0)
        //设置TabBar 选中背景色
        UITabBar.appearance().tintColor = UIColor(rgba:"#f0a22a")
        
        //键盘扩展
        IQKeyboardManager.sharedManager().enable = true
        
        // 友盟
        UMSocialData.setAppKey("563b6bdc67e58e73ee002acd")
        
        UMSocialQQHandler.setQQWithAppId("1104864621", appKey: "AQKpnMRxELiDWHwt", url: "www.itjh.net")
        
        UMSocialQQHandler.setSupportWebView(true)
        
        UMSocialSinaHandler.openSSO(withRedirectURL: "http://sns.whalecloud.com/sina2/callback")
        
        UMSocialWechatHandler.setWXAppId("wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", url: "www.doushi.me")
        
        
//            [MobClick startWithAppkey:UMAPPKey reportPolicy:(ReportPolicy) REALTIME channelId:nil];
        
        
        
        MobClick.start(withAppkey: "563b6bdc67e58e73ee002acd")
        
        
        //Share SMS
        SMSSDK.registerApp("c06e0d3b9ec2", withSecret: "ad02d765bad19681273e61a5c570a145")
        
        
        
        
        
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        
        
        
        // Required
        
        APService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue , categories: nil)
        
        
        // Required
        APService.setup(withOption: launchOptions)
        
        APService.setLogOFF()
        
        
        
        
        
        //设置3d touch
        
        //        if #available(iOS 9.0, *) {
        //            let firstItemIcon:UIApplicationShortcutIcon =  UIApplicationShortcutIcon(type: .Compose)
        //            let firstItem = UIMutableApplicationShortcutItem(type: "1", localizedTitle: "我的收藏", localizedSubtitle: nil, icon: firstItemIcon, userInfo: nil)
        //
        //            let firstItem2Icon:UIApplicationShortcutIcon =  UIApplicationShortcutIcon(type: .Pause)
        //            let firstItem2 = UIMutableApplicationShortcutItem(type: "2", localizedTitle: "排行榜", localizedSubtitle: nil, icon: firstItem2Icon, userInfo: nil)
        //
        //
        //            application.shortcutItems = [firstItem,firstItem2]
        //
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        
        
        
        
        return true
    }
    
    
    // MARK: 加载广告
    
    func initAd()  {
        
        
        self.oldLaunchView = UIImageView(image: UIImage(named: "LaunchImage"))
        
        self.oldLaunchView?.frame = (self.window?.bounds)!
        
        self.oldLaunchView?.contentMode = .scaleAspectFill
        
        self.window?.addSubview(oldLaunchView!)
        
        self.loadLaunchAd()
        
        
        
    }
    
    
    func loadLaunchAd() {
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: Selector(handleTimer()), userInfo: nil, repeats: false)
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        
        let launchScreenViewController = launchScreenStoryboard.instantiateViewController(withIdentifier: "launchScreen")
        
        self.launchView = launchScreenViewController.view
        
        self.window?.addSubview(self.launchView!)
        
        self.imgBg!.frame = (self.window?.frame)!
        
        self.launchView!.addSubview(self.imgBg!)
        
        self.window?.bringSubview(toFront: self.launchView!)
        
        
        
        
    }
  
    
    func handleTimer() {
//        self.imgBg!.removeFromSuperview()
//        self.launchView!.removeFromSuperview()
    }
    
    
    /**
     3D Touch 跳转
     
     - parameter application:       application
     - parameter shortcutItem:      item
     - parameter completionHandler: handler
     */
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
        
    }
    
    
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        //Get type string from shortcutItem
        // 获取当前页面TabBar
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        // 获取当前TabBar Nav
        let nav = tabBar.selectedViewController as! UINavigationController
        
        if shortcutItem.type == "1" {
            
            // My视图
            let storyMy = UIStoryboard(name: "My", bundle: nil)
            
            // 收藏列表页
            let myCollectView = storyMy.instantiateViewController(withIdentifier: "MyCollect") as! MyUserFavoriteTableViewController
            myCollectView.title = "我的收藏"
            // 跳转
            nav.pushViewController(myCollectView, animated: true)
            
            handled = true
        }
        if shortcutItem.type == "2" {
            
            // Find视图
            let storyMy = UIStoryboard(name: "Find", bundle: nil)
            
            // 排行榜列表页
            let videoTaxisView = storyMy.instantiateViewController(withIdentifier: "VideoTaxisTableViewController") as! VideoTaxisTableViewController
            videoTaxisView.title = "排行榜"
            // 跳转
            nav.pushViewController(videoTaxisView, animated: true)
            
            handled = true
        }
        return handled
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        APService.registerDeviceToken(deviceToken)
    }
    
    
    
    // 获取当前页面TabBar
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        
        UIApplication.shared.applicationIconBadgeNumber += 1


        // 获取当前TabBar Nav
        let nav = tabBar.selectedViewController as! UINavigationController
        
        
        APService.handleRemoteNotification(userInfo)
        
        
        //        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        let applicationState = UIApplication.shared.applicationState.rawValue
        
        let userInfoDict =  userInfo as NSDictionary
        
        let  aps = userInfoDict["aps"]  as! NSDictionary
        
        if applicationState == 0 {
            print("程序正在前台运行")
            let alertController = UIAlertController(title: aps["alert"] as? String, message: "搞笑视频来了! 是否查看", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                
                self.goPlayVideo(userInfoDict)
            }
            alertController.addAction(OKAction)
            
            //            presentViewController(alertController, animated: true) {
            //
            //            }
            
            nav.present(alertController, animated: true, completion: { () -> Void in
                
                
            })
            
            
            
        }else{
            self.goPlayVideo(userInfoDict)
            
        }
        
        
        
    }
    
    
    /**
     跳转播放视频
     
     - parameter userInfoDict: userInfoDict description
     */
    func goPlayVideo(_ userInfoDict:NSDictionary){
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        // 获取当前TabBar Nav
        let nav = tabBar.selectedViewController as! UINavigationController
        
        
        //播放
        let aStoryboard = UIStoryboard(name: "Home", bundle:Bundle.main)
        let playVideoViewController = aStoryboard.instantiateViewController(withIdentifier: "playVideoView") as! PlayVideoViewController
        
        let videoId =  userInfoDict["videoId"] as! String
        
        var userId = 0
        
        if (user != nil) {
            userId = user!.object(forKey: "id") as! Int
        }
        
        HttpController.getVideoById(HttpClientByVideo.DSRouter.getVideosById(videoId, userId), callback: { videoInfo -> Void in
            DataCenter.shareDataCenter.videoInfo = videoInfo!
            nav.pushViewController(playVideoViewController, animated: true)
        })

        
//        alamofireManager.request(HttpClientByVideo.DSRouter.getVideosById(videoId, userId)).responseJSON { response in
//            
//            switch response.result {
//            case .Success:
//                print("getVideosById Validation Successful")
//                if let JSON = response.result.value {
//                    if response.response?.statusCode == 200 {
//                        
//                        let videoDict = (JSON as! NSDictionary).valueForKey("content") as! NSDictionary
//                        
////                        playVideoViewController.videoTitleLabel = videoDict["title"] as! String
////                        
////                        playVideoViewController.videoInfoLable  = videoDict["title"] as! String
////                        
////                        playVideoViewController.isCollectStatus = videoDict["isCollectStatus"] as! Int
//                        
////                        playVideoViewController.videoUrlString = videoDict["videoUrl"] as! String
//                        
//                        playVideoViewController.userId = userId
//                        
////                        playVideoViewController.videoId = videoDict["id"] as! String
////                        
////                        playVideoViewController.videoPic = videoDict["pic"] as! String
////                        
//                        nav.pushViewController(playVideoViewController, animated: true)
//                        
//                    }
//                    
//                    
//                }
//                
//            case .Failure(let error):
//                print(error)
//            }
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)");
        
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "me.doushi.ds_ios" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ds_ios", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    
}

