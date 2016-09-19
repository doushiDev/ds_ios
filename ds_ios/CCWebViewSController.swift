//
//  CCWebViewSController.swift
//  WebViewDemo
//
//  Created by XZC on 15/11/27.
//  Copyright © 2015年 MMC. All rights reserved.
//

import UIKit
import WebKit

let WebViewNav_TintColor: UIColor = UIColor.orange
class CCWebViewSController: UIViewController,UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate {
    
    internal var homeUrl: URL?
    fileprivate  var progressView: UIProgressView?
    fileprivate  var webView: AnyObject?
    
    /** 传入控制器、url、标题 */
    class func showWithContro(_ contro: UIViewController,withUrlStr url: NSString,withTitle title: String) -> Void {
        let urlStr: String = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let webContro = CCWebViewSController()
        webContro.homeUrl =  URL(string: urlStr)!
        webContro.title = title
        contro.navigationController?.pushViewController(webContro, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.white
        self.configUI()
        self.configBackItem()
        self.configMenuItem()
    }
    
    func configUI() {
        
        // 进度条
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0))
        progressView.tintColor = WebViewNav_TintColor
        progressView.trackTintColor = UIColor.white
        self.view.addSubview(progressView)
        self.progressView = progressView
        
        // 网页
        if #available(iOS 8.0, *) {
            let wkWebView = WKWebView(frame: self.view.bounds)
            wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            wkWebView.backgroundColor = UIColor.white
            wkWebView.navigationDelegate = self
            self.view.insertSubview(wkWebView, belowSubview: progressView)
            
            wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            let request = URLRequest(url: self.homeUrl!)
            wkWebView.load(request)
            self.webView = wkWebView
        }else {
            let webView = UIWebView(frame: self.view.bounds)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.scalesPageToFit = true
            webView.backgroundColor = UIColor.white
            webView.delegate = self
            self.view.insertSubview(webView, belowSubview: progressView)
            
            let request = URLRequest(url: self.homeUrl!)
            webView.loadRequest(request)
            self.webView = webView
        }
        
    }
    
    func configBackItem() {
        
        // 导航栏的返回按钮
        var backImage = UIImage(named: "cc_webview_back")
        backImage = backImage?.withRenderingMode(.alwaysTemplate)
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 22))
        backBtn.tintColor = WebViewNav_TintColor
        backBtn.setImage(backImage, for: UIControlState())
        backBtn.addTarget(self, action: #selector(CCWebViewSController.backBtnPressed(_:)), for: .touchUpInside)
        
        let colseItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = colseItem
    }
    
    func configMenuItem() {
        
        // 导航栏的菜单按钮
        var menuImage = UIImage(named: "cc_webview_menu")
        menuImage = menuImage?.withRenderingMode(.alwaysTemplate)
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        menuBtn.tintColor = WebViewNav_TintColor
        menuBtn.setImage(menuImage, for: UIControlState())
        menuBtn.addTarget(self, action: #selector(CCWebViewSController.menuBtnPressed(_:)), for: .touchUpInside)
        
        let menuItem = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.rightBarButtonItem = menuItem
    }
    
    func configColseItem() {
        
        // 导航栏的关闭按钮
        let colseBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        colseBtn.setTitle("关闭", for: UIControlState())
        colseBtn.setTitleColor(WebViewNav_TintColor, for: UIControlState())
        colseBtn.addTarget(self, action: #selector(CCWebViewSController.colseBtnPressed(_:)), for: .touchUpInside)
        colseBtn.sizeToFit()
        
        let colseItem = UIBarButtonItem(customView: colseBtn)
        let newArr:[UIBarButtonItem] = [self.navigationItem.leftBarButtonItem!,colseItem]
        self.navigationItem.leftBarButtonItems = newArr
    }
    
    // MARK: - 普通按钮事件
    // 返回按钮点击
    func backBtnPressed(_ sender: AnyObject) {
        if self.webView?.canGoBack == true {
            self.webView?.goBack()
            if self.navigationItem.leftBarButtonItems?.count == 1 {
                self.configColseItem()
            }
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 菜单按钮点击
    func menuBtnPressed(_ sender: AnyObject) {
        if #available(iOS 8.0, *) {
            let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let defultAction1 = UIAlertAction(title: "safari打开", style: .default, handler: { (action) -> Void in
                self.actionSheetPress(0)
            })
            let defultAction2 = UIAlertAction(title: "复制链接", style: .default, handler: { (action) -> Void in
                self.actionSheetPress(1)
            })
            let defultAction3 = UIAlertAction(title: "分享", style: .default, handler: { (action) -> Void in
                self.actionSheetPress(2)
            })
            let defultAction4 = UIAlertAction(title: "刷新", style: .default, handler: { (action) -> Void in
                self.actionSheetPress(3)
            })
            actionController.addAction(cancelAction)
            actionController.addAction(defultAction1)
            actionController.addAction(defultAction2)
            actionController.addAction(defultAction3)
            actionController.addAction(defultAction4)
            self.present(actionController, animated: true, completion: nil)
        }else {
            // 在iOS7手机上swift中使用actionsheet有毒，取消按钮设置不了，只能这么做
            let actionSheet = UIActionSheet()
            actionSheet.delegate = self
            actionSheet.addButton(withTitle: "safari打开")
            actionSheet.addButton(withTitle: "复制链接")
            actionSheet.addButton(withTitle: "分享")
            actionSheet.addButton(withTitle: "刷新")
            actionSheet.addButton(withTitle: "取消")
            actionSheet.show(in: self.view)
        }
    }
    
    // 关闭按钮点击
    func colseBtnPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 菜单按钮事件
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        self.actionSheetPress(buttonIndex)
    }
    
    func actionSheetPress(_ buttonIndex: Int) {
        // 链接
        var urlStr = self.homeUrl?.absoluteString
        if #available(iOS 8.0, *) {
            urlStr = self.webView?.url!!.absoluteString
        }else {
            urlStr = self.webView?.request.url?.absoluteString
        }
        
        if buttonIndex == 0 {
            
            // safari打开
            UIApplication.shared.openURL(URL(string: urlStr!)!)
        }else if buttonIndex == 1 {
            
            // 复制链接
            if urlStr != nil {
                UIPasteboard.general.string = urlStr
                let alertView = UIAlertView(title: "已复制链接到黏贴板", message: nil, delegate: nil, cancelButtonTitle: "知道了")
                alertView.show()
            }
        }else if buttonIndex == 2 {
            
            // 分享
            //self.webView?.evaluateJavaScript("这里写js代码", completionHandler: { (reponse, error) -> Void in
            //print("返回的结果：\(reponse)")
            //})
            print("这里自己写，分享url：\(urlStr)")
        }else if buttonIndex == 3 {
            
            // 刷新
            self.webView?.reload()
        }
    }
    
    // MARK: - wkWebView代理
    // 如果不添加这个，那么wkwebview跳转不了AppStore
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (webView.url?.absoluteString.hasPrefix("https://itunes.apple.com")) == true {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        }else {
            decisionHandler(.allow)
        }
    }
    
    // 计算wkWebView进度条
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let newProgress = change?["new"] as! Float
            if newProgress == 1 {
                self.progressView?.isHidden = true
                self.progressView?.setProgress(0, animated: true)
            }else {
                self.progressView?.isHidden = false
                self.progressView?.setProgress(newProgress, animated: true)
            }
        }
    }
    
    // 记得取消监听
    deinit {
        if #available(iOS 8.0, *) {
            self.webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
    
    // MARK: - webView代理
    // 计算webView进度条
    var loadCount:Int = 0 {
        willSet {
            if newValue == 0 {
                self.progressView?.isHidden = true
                self.progressView?.setProgress(0, animated: false)
            }else {
                self.progressView?.isHidden = false
                let oldP = self.progressView?.progress
                var newP = (1.0 - oldP!) / Float(newValue + 1) + oldP!
                if newP > 0.95 {
                    newP = 0.95
                }
                self.progressView?.setProgress(newP, animated: true)
            }
        }
        didSet {
            
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.loadCount += 1
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadCount -= 1
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loadCount -= 1
    }
}
