//
//  AppDelegate.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/24.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import Firebase
import Realm
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        
        /* 打开调试日志 */
//        [[UMSocialManager defaultManager] openLog:YES];
        
        
//        
//        /* 设置友盟appkey */
//        [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
//        
//        [self configUSharePlatforms];
//        
//        [self confitUShareSettings];
        
        
        let umAnalyticsConfig = UMAnalyticsConfig()
        
        umAnalyticsConfig.appKey = "563b6bdc67e58e73ee002acd"
        umAnalyticsConfig.channelId = "App Store"
        
        MobClick.start(withConfigure: umAnalyticsConfig)
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        
        MobClick.setAppVersion(version)
        
        UMSocialManager.default().openLog(true)
        
        UMSocialManager.default().umSocialAppkey = "563b6bdc67e58e73ee002acd"
        
        self.configUSharePlatforms()
        
        // Use Firebase library to configure APIs.
        FIRApp.configure()
        // Initialize Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-7191090490730162/3156733936")

        var config = Realm.Configuration()
        
        if config.fileURL == nil {
            
            // 使用默认的目录，但是使用用户名来替换默认的文件名
            let uuid:String = (UIDevice.current.identifierForVendor?.uuidString)!
            config.fileURL = config.fileURL!.deletingLastPathComponent()
                .appendingPathComponent("\(uuid).realm")
            
            // 将这个配置应用到默认的 Realm 数据库当中
            Realm.Configuration.defaultConfiguration = config
        }
        

        
        return true
    }
    
    
    
    
    func configUSharePlatforms() {
        
    
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wxfd23fac852a54c97", appSecret: "d4624c36b6795d1d99dcf0547af5443d", redirectURL: "http://yh.itjh.net")
        
        
        UMSocialManager.default().setPlaform(.QQ, appKey: "1104864621", appSecret: nil, redirectURL: "http://yh.itjh.net")
        
        UMSocialManager.default().setPlaform(.sina, appKey: "847382581", appSecret: "eeac00a87cfb61bf2bf3374523c7354f", redirectURL: "sns.whalecloud.com")
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result{
            
        }
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result{
            
        }
        return result
    }

}

