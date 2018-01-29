//
//  MainViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/25.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture
import Foundation

class MainViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    /// 子标题
    lazy var subTitleArr:[String] = {
        return ["推荐", "娱乐", "搞笑", "小品", "游戏"]
    }()
    
    /// 子控制器
    var controllers:[UIViewController] = {
        // 创建5个子控制器
        var cons:[UIViewController] = [UIViewController]()
        
        var controllerArray : [UIViewController] = []
        
        // Do any additional setup after loading the view.
        let aStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        
        
        let newVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        newVideoTableViewController.cid = 33
        newVideoTableViewController.view.tag = 33
        
        let hotVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        hotVideoTableViewController.cid = 17
        hotVideoTableViewController.view.tag = 17
        let popVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController.cid = 6
        popVideoTableViewController.view.tag = 6
        
        let popVideoTableViewController1 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController1.cid = 35
        popVideoTableViewController1.view.tag = 35
        
        let popVideoTableViewController2 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController2.cid = 13
        popVideoTableViewController2.view.tag = 13
        
        controllerArray.append(newVideoTableViewController)
        controllerArray.append(hotVideoTableViewController)
        controllerArray.append(popVideoTableViewController)
        controllerArray.append(popVideoTableViewController1)
        controllerArray.append(popVideoTableViewController2)

        
        
        
        //        for _ in 0..<5 {
        //            // 创建随机颜色
        //            let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        //            let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        //            let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        //            let colorRun = UIColor.init(red:red, green:green, blue:blue , alpha: 1)
        //
        //            let subController = UIViewController()
        //            subController.view.backgroundColor = colorRun
        //            cons.append(subController)
        //        }
        return controllerArray
    }()
    
    
    /// 菜单分类控制器
    lazy var lxfMenuVc: LXFMenuPageController = {
        let pageVc = LXFMenuPageController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        //        pageVc.delegate = self
        self.view.addSubview(pageVc.view)
        return pageVc
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        lxfMenuVc.tipBtnFontSize = 14
        
    
        if UIDevice.isX() {
            lxfMenuVc.view.frame = CGRect(x: 0.0, y: 90, width: self.view.frame.width, height: self.view.frame.height - 112)
        }else{
            
            lxfMenuVc.view.frame = CGRect(x: 0.0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     视图全部加载完 出现
     
     - parameter animated: animated description
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool{
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        
        return true
    }
    
    
    
}

