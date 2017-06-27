//
//  MainViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/25.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class Main2ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    /// 子标题
    lazy var subTitleArr:[String] = {
        return ["旅游", "汽车", "生活", "刺激", "两性"]
    }()
    
    /// 子控制器
    var controllers:[UIViewController] = {
        // 创建5个子控制器
        var cons:[UIViewController] = [UIViewController]()
        
        var controllerArray : [UIViewController] = []
        
        // Do any additional setup after loading the view.
        let aStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        
        
        let popVideoTableViewController1 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController1.cid = 15
        popVideoTableViewController1.view.tag = 15
        
        let popVideoTableViewController18 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController18.cid = 18
        popVideoTableViewController18.view.tag = 18
        
        let popVideoTableViewController2 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController2.cid = 20
        popVideoTableViewController2.view.tag = 20
        
        
        
        
        let popVideoTableViewController3 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController3.cid = 29
        popVideoTableViewController3.view.tag = 29
        
        let popVideoTableViewController4 = aStoryboard.instantiateViewController(withIdentifier: "HomeVideoTableViewController") as! HomeVideoTableViewController
        popVideoTableViewController4.cid = 37
        popVideoTableViewController4.view.tag = 37
        
        
        controllerArray.append(popVideoTableViewController1)
        controllerArray.append(popVideoTableViewController18)
        controllerArray.append(popVideoTableViewController2)
        controllerArray.append(popVideoTableViewController3)
        
        controllerArray.append(popVideoTableViewController4)
        
        
        
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
        
        
        
        lxfMenuVc.view.frame = CGRect(x: 0.0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112)
        
        
        //        let parameters: [CAPSPageMenuOption] = [
        //            .selectedMenuItemLabelColor(UIColor(rgba:"#f0a22a")),
        //            .unselectedMenuItemLabelColor(UIColor(rgba:"#939395")),
        //            .scrollMenuBackgroundColor(UIColor(rgba: "#f2f2f2")),
        //            .viewBackgroundColor(UIColor.white),
        //            .selectionIndicatorColor(UIColor(rgba:"#fea113")),
        //            .bottomMenuHairlineColor(UIColor(rgba:"#f2f2f2")),
        //
        //            .menuItemFont(UIFont(name: "AvenirNextCondensed-DemiBold", size: 13.0)!),
        //            .menuHeight(40.0),
        //            .menuItemWidth(90.0),
        //
        //
        //            .centerMenuItems(true)
        //        ]
        
        //
        //        NSDictionary *parameters = @{
        //            CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
        //            CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
        //            CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
        //            CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
        //            CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
        //            CAPSPageMenuOptionMenuHeight: @(40.0),
        //            CAPSPageMenuOptionMenuItemWidth: @(90.0),
        //            CAPSPageMenuOptionCenterMenuItems: @(YES)
        //        };
        
        
        //        var parameters:Dictionary = [Any: Any]()
        
        
        
        
        
        //        _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
        
        
        //        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112), options: [CAPSPageMenuOptionMenuHeight : 40])
        //
        
        //        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112), pageMenuOptions: parameters)
        
        
        
        //        self.addChildViewController(pageMenu!)
        
        //        self.view.addSubview(pageMenu!.view)
        
        //        pageMenu!.didMove(toParentViewController: self)
        
        
        
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
